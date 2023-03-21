defmodule Health do
  defstruct name: '_', team: '_', health: 0

  defimpl String.Chars, for: Health do
    def to_string(h) do
      "(#{h.team}\t#{h.health}\t#{h.name})"
    end
  end

  use GenServer

  require Logger

  @timing 2

  def parse(health_string) do
    lines = String.split(health_string, "\n")
    lines |> Enum.map(fn line ->
      m = Regex.named_captures(~r/(?<team>[^:]+): (?<name>[^:]+): (?<health>[\d]+)/, line)
      if is_nil(m) do
        nil
      else
        %Health{team: Map.get(m, "team"), name: Map.get(m, "name"), health: String.to_integer(Map.get(m, "health"))}
      end
    end) |> Enum.filter(fn i -> not is_nil(i) end)
  end

  def start_link(_ \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: Health)
  end

  def init(:ok) do
    {:ok, %{toggle: false, health: ""}}
  end

  def start() do
    send(Health, :start)
  end

  def stop() do
    send(Health, :stop)
  end

  def toggle() do
    send(Health, :toggle)
  end

  def handle_info(:start, state) do
    is_on = Map.get(state, :toggle)
    if not is_on do
      poll()
    end
    state = Map.put(state, :toggle, true)
    {:noreply, state}
  end

  def handle_info(:toggle, state) do
    is_on = Map.get(state, :toggle)
    if not is_on do
      poll()
      # start()
    end
    state = Map.put(state, :toggle, not is_on)
    {:noreply, state}
  end

  def handle_info(:stop, state) do
    state = Map.put(state, :toggle, false)
    {:noreply, state}
  end

  def handle_info(:health, state) do
    is_on = Map.get(state, :toggle)
    if is_on do
      {out, _} = System.cmd("#{
      Application.app_dir(Application.get_application(__MODULE__), "priv")
      }/external/health.sh", ["silence"])
      players = parse(out)
      rem_health = players
      |> Enum.filter(fn i ->
        i.health > 0 and i.health < 100 and i.team != "CT"
      end)
      |> Enum.reduce([], fn i, acc ->
        Logger.debug("#{i}")
        [i.health | acc]
        end
      ) |> Enum.sort |> Enum.join(", ")
      state = if Map.get(state, :health) != rem_health or Map.get(state, :time) < System.os_time(:second) - 15 do
        if rem_health != "" do
          Display.show(rem_health)
          Console.execute("say_team #{rem_health}")
        else
          if Map.get(state, :health) != "" do
            Display.show(rem_health)
            Console.execute("say_team gg")
          end
        end
        Map.put(state, :health, rem_health)
        |> Map.put(:time, System.os_time(:second))
      else
        state
      end
      poll()
      {:noreply, state}
    else
      {:noreply, state}
    end
  end

  defp poll(),
    do: Process.send_after(self(), :health, 1000)

end
