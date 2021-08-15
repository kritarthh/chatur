defmodule Chat do
  use GenServer
  require Logger

  def say(lines) do
    lines
    |> Enum.each(fn line ->
      Console.execute("say_team " <> line)
      Process.sleep(750)
    end)
  end

  def parse(line) do
    [xyz, alphabeta] = String.split(line, " in ")

    [x, y, z] =
      String.split(xyz, " ")
      |> Enum.slice(1..-1)
      |> Enum.map(fn i -> String.to_float(i) end)

    [alpha, beta, gamma] =
      String.split(alphabeta, " ")
      |> Enum.slice(1..-1)
      |> Enum.map(fn i -> String.to_float(i) end)

    %Location{x: x, y: y, z: z, alpha: alpha, beta: beta, gamma: gamma}
  end

  def collect(lines, _delimiter) do
    receive do
      {:collect, line, delimiter} ->
        cond do
          String.starts_with?(line, delimiter) ->
            lines

          true ->
            collect([line | lines], delimiter)
        end

      _ ->
        lines
    end
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, []}
  end

  def handle_info({:collect, line, delimiter}, _state) do
    cond do
      String.starts_with?(line, "Damage Given to ") ->
        lines = collect([line], delimiter)
        Logger.debug("Collected lines are #{inspect(lines)}")
        say(lines)
        {:noreply, lines}

      true ->
        {:noreply, []}
    end
  end
end
