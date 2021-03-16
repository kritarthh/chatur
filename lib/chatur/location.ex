defmodule Location do
  defstruct [x: 0, y: 0, z: 0, alpha: 0, beta: 0, gamma: 0]

  defimpl String.Chars, for: Location do
    def to_string(l) do
      "(#{l.x}, #{l.y}, #{l.z}) (#{l.alpha}, #{l.beta})"
    end
  end

  use Agent
  require Logger

  def parse(location_string) do
    [xyz, alphabeta] = String.split(location_string, ";")
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

  def start_link(opts) do
    Agent.start_link(fn -> %Location{} end, opts)
  end

  def get() do
    Agent.get(Location, fn location -> location end)
  end

  def set(pos) do
    Logger.debug("Location.set agent to #{pos}")
    Agent.update(Location, fn _ -> parse(pos) end)
  end

  def set(x, y, z, a, b, c) do
    Agent.update(Location, fn location -> %Location{x: x, y: y, z: z, alpha: a, beta: b, gamma: c} end)
  end
end
