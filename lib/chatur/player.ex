defmodule Player do
  require Logger

  use GenServer

  defstruct location: %Location{}, map: "", team: ""

  require Logger
  require Integer

  def flush() do
    receive do
      _ -> flush()
    after
      0 ->
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

  def binds() do
    for k <- Nade.keys() do
      Console.execute(~s/bind #{k} "echo #{k}"/)
    end

    Console.execute(~s/bind I "echo show_nade_options"/)
    Console.execute(~s/bind O "echo stop_movement"/)

    Console.execute(
      ~s/alias "+jumpthrow" "+jump;-attack"; alias "-jumpthrow" "-jump"; bind f6 "+jumpthrow";/
    )

    Console.execute("con_logfile cfg/chatur/console.log")

    # Console.execute(
    #   ~s/bind \] "use weapon_knife; use weapon_c4; drop; say_team I HAVE DROPPED THE BOMB"/
    # )

    Console.execute(~s/con_filter_text_out "Execing config"/)
    Console.execute("net_client_steamdatagram_enable_override 1")
    Console.execute("sensitivity")
  end

  def update() do
    # {:reply, :ok, l} = send(Player, :get_location)
    Logger.info("Updating Player")
    binds()
    send(Player, {:get_status, self()})
  end

  def wait_for_csgo() do
    if Input.is_active() == false do
      Logger.info("Waiting for CSGO to start")
      Process.sleep(2000)
      wait_for_csgo()
    end
  end

  def start_link(_ \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: Player)
  end

  def init(:ok) do
    # wait for the csgo process here
    wait_for_csgo()
    Logger.info("CSGO started, initializing")
    update()
    {:ok, %Player{}}
  end

  def handle_call(:get_map, _from, state) do
    {:reply, state.map, state}
  end

  def handle_info({:get_location, pid}, state) do
    {out, _} = System.cmd("#{
        Application.app_dir(Application.get_application(__MODULE__), "priv")
      }/external/location.sh", [])
    location = Location.parse(out)
    send(pid, location)
    {:noreply, Map.put(state, :location, location)}
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
        Logger.debug("Timed out waiting for status, use last")
        {:noreply, state}
    end
  end

  def handle_info({:map, m}, state) do
    Logger.debug("update map to #{m}")
    Nade.init_maps_agents(Nade.map_store(m))
    Nade.map_store(m).update()
    {:noreply, Map.put(state, :map, m)}
  end

  def handle_info({:location, l}, state) do
    Logger.warn("Unwanted location (#{l})")
    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.warn("Unwanted message #{msg}")
    {:noreply, state}
  end
end
