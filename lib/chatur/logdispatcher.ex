defmodule LogDispatcher do
  use GenServer

  require Logger

  def start_link(_ \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: LogDispatcher)
  end

  def init(:ok) do
    # open the log file and set the pointer to the end so that we only grab
    # new log messages
    {:ok, []}
  end

  def handle_cast({:log_line, line}, state) do
    cond do
      String.contains?(line, "Ragdoll") ->
        Logger.debug("saying #{line}")
      String.contains?(line, ";setang ") ->
        send(Player, {:location, Location.parse(line)})
      String.starts_with?(line, "map ") ->
        send(Player, {:map, line |> String.split(" ") |> Enum.filter(fn t -> t != "" end) |> Enum.at(2)})
      String.starts_with?(line, "Damage Given to ") or String.starts_with?(line, "Player: ") ->
        send(Chat, {:collect, line, "Player: "})
      String.starts_with?(line, "Started tracking Steam Net Connection to") ->
        Logger.debug("Match found accepting code goes here")
      line == "Counter-Strike: Global Offensive" ->
        Logger.debug("Connected to match, update player")
        Player.update()
      line == "#end" ->
        send(Player, :status)
      line == "pronade" ->
        send(Movement, :pronade)
      line == "chatur" ->
        Player.init(:ok)
      line == "stop_movement" ->
        Movement.kill()
      line == "show_nade_options" ->
        spawn(fn -> Nade.overlay() end)
      line == "test" ->
        send(Movement, :approach_position_test)
      line == "usbreset" ->
        Shell.execute("sudo /home/blackie/workspace/personal/scripts/usbreset.sh")
      Nade.key(line) ->
        spawn(fn -> Nade.overlay(line) end                            )
      true ->
        Logger.debug("Log line \"#{line}\" received")
    end
    {:noreply, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

end
