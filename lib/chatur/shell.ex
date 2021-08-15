defmodule Shell do
  require Logger

  def execute(command) do
    splits =
      command
      |> String.split(" ")

    # Logger.debug("Executing #{Enum.at(splits, 0)} [ #{Enum.join(Enum.slice(splits, 1..-1), " ")} ]")
    {out, _} = System.cmd(Enum.at(splits, 0), Enum.slice(splits, 1..-1))
    out
  end

  def execute(command, args) when is_list(args) do
    {out, _} = System.cmd(command, args)
    out
  end

  def execute(command, args) when is_binary(args) do
    {out, _} = System.cmd(command, String.split(args, " "))
    out
  end

  def bash(command) do
    {out, _} = System.cmd("bash", ["-c", command])
    out
  end
end
