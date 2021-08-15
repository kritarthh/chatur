defmodule Movement.Angle do
  require Logger

  @mr 8192

  defp sign(n) when n < 0, do: -1
  defp sign(n) when n >= 0, do: 1

  def normalize(theta) do
    theta +
    cond do
      theta > 180 ->
        -360

      theta < -180 ->
        360

      true ->
        0
    end
  end


  def find_angle(cl, dl, apmu \\ 0.022) do
    dx = dl.x - cl.x
    dy = dl.y - cl.y
    theta =
      cond do
        dy == 0 ->
          0
        dx == 0 ->
          0
        true ->
          Math.rad2deg(Math.atan(dy / dx))
      end

    theta =
      theta +
        cond do
          dx >= 0 ->
            if dy >= 0 do
              Logger.debug("QUADRANT 1: correction 0 : theta = #{theta}")
            else
              Logger.debug("QUADRANT 4: correction 0 : theta = #{theta}")
            end
            0
          dx < 0 ->
            if dy >= 0 do
              Logger.debug("QUADRANT 2: correction +180 : theta = #{theta + 180}")
              180
            else
              Logger.debug("QUADRANT 3: correction -180 : theta = #{theta - 180}")
              -180
            end
        end

    theta = if theta == 0 do
          # 0
          normalize(theta - cl.beta)
        else
          normalize(theta - cl.beta)
        end

    Logger.debug("final theta=#{theta}")
    theta

  end

  def approach(cl, dl, apmu) do
    # dl = Location.parse("setpos 1212.414673 -168.633850 -99.906189;setang -53.858582 -88.982597 0.000000")
    # apmu = GenServer.call(Movement, :apmu)
    approach_angle(cl, dl, apmu)
  end

  def approach_angle(cl, dl, apmu \\ 0.022) do
    theta = find_angle(cl, dl)
    rtheta = theta / apmu
    rate =
      if abs(rtheta) < 0.5,
        do: sign(rtheta),
        else: if(abs(rtheta) > @mr, do: sign(rtheta) * @mr, else: round(rtheta))

    cond do
      abs(theta) <= 0 ->
        nil

      theta != 0 ->
        Movement.move(-rate, 0)
        # approach_angle(dl, apmu)
    end
  end
end
