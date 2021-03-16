defmodule Player do
  use GenServer

  defstruct [location: %Location{}, map: "", team: ""]

  require Logger
  require Integer

  def flush() do
    receive do
      _ -> flush()
    after 0 ->
        :ok
    end
  end

  def getpos() do
    # {:reply, :ok, l} = send(Player, :get_location)
    send(Player, {:get_location, self()})
    receive do
      %Location{alpha: _, beta: _} = l ->
        l
    after
      1000 ->
        Logger.error("timed out, should not happen")
    end
  end

  def get_map() do
    GenServer.call(Player, :get_map)
  end

  def update() do
    # {:reply, :ok, l} = send(Player, :get_location)
    send(Player, {:get_status, self()})
  end

  def start_link(_ \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: Player)
  end

  defp binds() do
    Console.execute("")
    for k <- Nade.keys() do
      Console.execute("bind #{k} \"echo #{k}\"")
    end
    Console.execute("bind C \"echo show_nade_options\"")
    Console.execute('alias "+jumpthrow" "+jump;-attack"; alias "-jumpthrow" "-jump"; bind alt "+jumpthrow"')
  end

  def init(:ok) do
    # open the log file and set the pointer to the end so that we only grab
    # new log messages
    binds()
    update()
    {:ok, %Player{}}
  end

  def handle_call(:get_map, _from, state) do
    {:reply, state.map, state}
  end

  def handle_info({:get_location, pid}, state) do
    # ask logreader to read the log
    send(LogReader, {:read_until, ~r/^setpos.*;setang\ .*$/})

    Console.execute("getpos")

    receive do
      {:location, location} ->
        send(pid, location)
        {:noreply, Map.put(state, :location, location)}
    after
      500 ->
        Logger.warn("Timed out waiting for location, use last")
        send(pid, state.location)
        {:noreply, state}
    end
  end

  def handle_info({:get_status, _pid}, state) do
    # ask logreader to read the logs until the delimiter is read
    send(LogDispatcher, {:read_until, ~r/^#end$/})
    Console.execute("status")

    receive do
      :status ->
        Logger.debug("got status")
        {:noreply, state}
    after
      500 ->
        Logger.warn("Timed out waiting for status, use last")
        {:noreply, state}
    end
  end

  def handle_info({:map, m}, state) do
    Logger.debug("update map to #{m}")
    {:noreply, Map.put(state, :map, m)}
  end

  def handle_info({:location, l}, state) do
    Logger.warn("Unwanted location (#{l.alpha}, #{l.beta})")
    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.warn("Unwanted message #{msg}")
    {:noreply, state}
  end


end
