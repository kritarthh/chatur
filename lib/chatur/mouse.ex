defmodule Mouse do
  require Logger
  require Integer

  def get_current_location() do
    Shell.execute("xdotool getmouselocation")
    |> String.split(" ")
    |> Enum.slice(0..1)
    |> Enum.map(fn x ->
      x
      |> String.split(":")
      |> Enum.with_index()
      |> Enum.map_every(1, fn {y, idx} ->
        if Integer.is_odd(idx), do: String.to_integer(y), else: String.to_atom(y)
      end)
      |> List.to_tuple()
    end)
    |> Enum.into(%{})
  end

  def move(x, y, relative \\ true) do
    Logger.debug(
      "Moving mouse to (#{x},#{y}) #{if relative, do: "relatively", else: "absolutely"}"
    )

    Shell.execute("xdotool mousemove#{if relative, do: "_relative"} -- #{x} #{y}")
  end

  def approach(x, y, type \\ :nonlinear, r \\ 0.05, mr \\ 20) do
    %{x: cx, y: cy} = get_current_location()
    Logger.debug("Approaching (#{x}, #{y}) from (#{cx}, #{cy}) with type #{type}")

    dx = x - cx
    dy = y - cy

    rdx = round(r * dx)
    rdy = round(r * dy)

    ratex =
      if abs(rdx) < 1,
        do: dx,
        else: if(abs(rdx) > mr, do: round(mr * (rdx / abs(rdx))), else: rdx)

    ratey =
      if abs(rdy) < 1,
        do: dy,
        else: if(abs(rdy) > mr, do: round(mr * (rdy / abs(rdy))), else: rdy)

    cond do
      dx == 0 && dy == 0 ->
        nil

      dx != 0 || dy != 0 ->
        move(ratex, ratey)
        approach(x, y, type, r)
    end
  end
end
