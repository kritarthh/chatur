defmodule Movement do
  use GenServer

  require Logger
  require Integer

  @max_moves 1000
  @jump_throw_key "F6"

  defp get_random_string(length) do
    1..length
    |> Enum.reduce([], fn _, acc ->
      [Enum.random(String.split("abcdefghijklmnopqrstuvwxyz", "")) | acc]
    end)
    |> Enum.join("")
  end

  # tmp_file = "/tmp/#{get_random_string(10)}"

  defp get_moves(x, y) do
    lx = Enum.to_list(0..round(x))
    step = if x == 0, do: 1, else: y / x
    ly = Enum.map(lx, &round(&1 * step))

    Enum.zip(lx, ly)
    |> Enum.take_every(round(abs(x) / @max_moves + 1))
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [{x1, y1}, {x2, y2}] -> {x2 - x1, y2 - y1} end)
  end

  def move(x, y) do
    [command] = Input.mouse_format(["#{x} #{y}"])
    Input.execute_command(command)
  end

  def kill() do
    case Process.whereis(Movement) do
      nil -> :ok
      pid -> Process.exit(pid, :kill)
    end
  end

  defp sign(n) when n < 0, do: -1
  defp sign(n) when n >= 0, do: 1

  def find_key(l, dx, dy, beta, wid) do
    theta =
      cond do
        dx == 0 ->
          90

        true ->
          Math.rad2deg(Math.atan(dy / dx))
      end

    theta =
      theta +
        cond do
          dx >= 0 ->
            if dy >= 0 do
              Logger.debug("QUADRANDT 1: correction 0 : theta = #{theta}")
            else
              Logger.debug("QUADRANDT 4: correction 0 : theta = #{theta}")
            end

            0

          dx < 0 ->
            if dy >= 0 do
              Logger.debug("QUADRANDT 2: correction +180 : theta = #{theta + 180}")
              180
            else
              Logger.debug("QUADRANDT 3: correction -180 : theta = #{theta - 180}")
              -180
            end
        end

    Logger.debug("beta=#{beta}, theta=#{theta}")
    theta = theta - beta
    Logger.debug("final theta=#{theta}")

    theta =
      theta +
        cond do
          theta > 180 ->
            -360

          theta < -180 ->
            360

          true ->
            0
        end

    hyp = Math.sqrt(dx * dx + dy * dy)
    sinx = Math.sin(theta)
    cosx = Math.cos(theta)

    cond do
      theta >= 0 ->
        if theta > 0 do
          # Input.send_input(:key, :up, "d", wid)
          # Input.send_input(:key, :up, "D", wid)

          # if abs(hyp * sinx) > 100 do
          #   Input.send_input(:key, :down, "a", wid)
          # else
            # Input.send_input(:key, :down, "A", wid)
            # Process.sleep(100)
            # Input.send_input(:key, :up, "A", wid)
          # end

          if theta <= 90 do
            if theta < 90 do
              Input.send_input(:key, :up, "s", wid)
              Input.send_input(:key, :up, "S", wid)

              if hyp * cosx > 100 do
                Input.send_input(:key, :down, "w", wid)
              else
                Input.send_input(:key, :down, "W", wid)
                if hyp * cosx < 25 do
                  Process.sleep(100)
                  Input.send_input(:key, :up, "W", wid)
                end
              end
            end
          else
            Input.send_input(:key, :up, "w", wid)
            Input.send_input(:key, :up, "W", wid)

            if hyp * cosx > 100 do
              Input.send_input(:key, :down, "s", wid)
            else
              Input.send_input(:key, :down, "S", wid)
              if hyp * cosx < 25 do
                  Process.sleep(100)
                Input.send_input(:key, :up, "S", wid)
              end
              # Process.sleep(100)
              # Input.send_input(:key, :up, "S", wid)
            end
          end
        end

      theta < 0 ->
        # Input.send_input(:key, :up, "a", wid)
        # Input.send_input(:key, :up, "A", wid)

        # if abs(hyp * sinx) > 100 do
        #   Input.send_input(:key, :down, "d", wid)
        # else
          # Input.send_input(:key, :down, "D", wid)
          # Process.sleep(100)
          # Input.send_input(:key, :up, "D", wid)
        # end

        if theta >= -90 do
          if theta > -90 do
            Input.send_input(:key, :up, "s", wid)
            Input.send_input(:key, :up, "S", wid)

            if abs(hyp * cosx) > 100 do
              Input.send_input(:key, :down, "w", wid)
            else
              Input.send_input(:key, :down, "W", wid)
              if hyp * cosx < 25 do
                  Process.sleep(100)
                Input.send_input(:key, :up, "W", wid)
              end
              # Process.sleep(100)
              # Input.send_input(:key, :up, "W", wid)
            end
          end
        else
          Input.send_input(:key, :up, "w", wid)
          Input.send_input(:key, :up, "W", wid)

          if abs(hyp * cosx) > 100 do
            Input.send_input(:key, :down, "s", wid)
          else
            Input.send_input(:key, :down, "S", wid)
            if hyp * cosx < 25 do
                  Process.sleep(100)
              Input.send_input(:key, :up, "S", wid)
            end
            # Process.sleep(100)
            # Input.send_input(:key, :up, "S", wid)
          end
        end
    end
  end

  def approach_position(l, apmu, aa \\ true) do
    cl = Player.getpos()
    Logger.debug("Approaching (#{l.x}, #{l.y}, #{l.z}) from (#{cl.x}, #{cl.y}, #{cl.z})")

    dx = l.x - cl.x
    dy = l.y - cl.y

    cond do
      dx == 0 ->
        Logger.debug("on x")

      abs(dx) > 25 ->
        Logger.debug("far away in x")

      abs(dx) < 25 ->
        Logger.debug("closer in x")
    end

    cond do
      dy == 0 ->
        Logger.debug("on y")

      abs(dy) > 25 ->
        Logger.debug("far away in y")

      abs(dy) < 25 ->
        Logger.debug("closer in y")
    end

    wid = Input.is_active()

    cond do
      abs(dx) + abs(dy) <= 0.5 ->
        Input.send_input(:key, :up, "w", wid)
        Input.send_input(:key, :up, "a", wid)
        Input.send_input(:key, :up, "s", wid)
        Input.send_input(:key, :up, "d", wid)
        Input.send_input(:key, :up, "W", wid)
        Input.send_input(:key, :up, "A", wid)
        Input.send_input(:key, :up, "S", wid)
        Input.send_input(:key, :up, "D", wid)
        nil

      dx != 0 || dy != 0 ->
        if aa do
          Movement.Angle.approach(cl, l, apmu)
        else
          find_key(cl, dx, dy, cl.beta, wid)
        end
        approach_position(l, apmu, not aa)
    end
  end

  def approach(l, apmu \\ 0.022, r \\ 4, mr \\ 4096) do
    cl = Player.getpos()

    Logger.debug(
      "Approaching (#{l.alpha}, #{l.beta}, #{l.gamma}) from (#{cl.alpha}, #{cl.beta}, #{cl.gamma})"
    )

    dx = l.beta - cl.beta
    dy = l.alpha - cl.alpha

    dx = Movement.Angle.normalize(dx)

    # rdx = (r * :math.pow(dx, 2) * sign(dx))
    # rdy = (r * :math.pow(dy, 2) * sign(dy))

    rdx = dx / apmu
    rdy = dy / apmu

    ratex =
      if abs(rdx) < 0.5,
        do: sign(rdx),
        else: if(abs(rdx) > mr, do: sign(rdx) * mr, else: round(rdx))

    ratey =
      if abs(rdy) < 0.5,
        do: sign(rdy),
        else: if(abs(rdy) > mr, do: sign(rdy) * mr, else: round(rdy))

    cond do
      abs(dx) <= apmu && abs(dy) <= apmu ->
        nil

      dx != 0 || dy != 0 ->
        move(-ratex, ratey)
        approach(l, apmu)
    end
  end

  def jump() do
    case Input.is_active() do
      false -> :err
      true -> Input.type(" ")
      wid -> Input.type(" ", wid)
    end
  end

  def jump_throw(mb \\ :left) do
    case Input.is_active() do
      false ->
        :err

      wid ->
        Input.send_input(:mouse, :down, mb, wid)
        Process.sleep(100)
        if jump do
          # clicking this does not work 100% so pressing and releasing
          Input.send_input(:key, :down, @jump_throw_key, wid)
          Process.sleep(100)
          Input.send_input(:key, :up, @jump_throw_key, wid)
        end
        Input.send_input(:mouse, :up, mb, wid)
        # Input.type(" ", wid)
    end
  end

  def move_throw(
        duration \\ 100,
        jump \\ true,
        lmb \\ true,
        rmb \\ false,
        walk \\ false,
        move_key \\ "w"
      ) do
    case Input.is_active() do
      false ->
        :err

      wid ->
        if lmb, do: Input.send_input(:mouse, :down, :left, wid)
        if rmb, do: Input.send_input(:mouse, :down, :right, wid)
        Process.sleep(100)

        if duration > 0 do
          Input.send_input(
            :key,
            :down,
            "#{if walk, do: String.upcase(move_key), else: move_key}",
            wid
          )

          Process.sleep(duration)
        end

        if jump do
          Logger.info("Send jumpthrow bind")
          # clicking this does not work 100% so pressing and releasing
          Input.send_input(:key, :down, @jump_throw_key, wid)
          Process.sleep(100)
          Input.send_input(:key, :up, @jump_throw_key, wid)
        end
        if lmb, do: Input.send_input(:mouse, :up, :left, wid)
        if rmb, do: Input.send_input(:mouse, :up, :right, wid)
        # if jump, do: Input.type(" ", wid)

        if duration > 0 do
          Process.sleep(250)

          Input.send_input(
            :key,
            :up,
            "#{if walk, do: String.upcase(move_key), else: move_key}",
            wid
          )
        end
    end
  end

  def walk(duration \\ 100, key \\ "W") do
    case Input.is_active() do
      false ->
        :err

      wid ->
        Input.send_input(:key, :down, key, wid)
        Process.sleep(duration)
        Input.send_input(:key, :up, key, wid)
    end
  end

  def run(duration \\ 100, key \\ "w") do
    case Input.is_active() do
      false ->
        :err

      wid ->
        Input.send_input(:key, :down, key, wid)
        Process.sleep(duration)
        Input.send_input(:key, :up, key, wid)
    end
  end

  def fire(click \\ 1) do
    case Input.is_active() do
      false ->
        :err

      wid ->
        case click do
          1 ->
            Input.send_input(:mouse, :click, :left, wid)

          2 ->
            Input.send_input(:mouse, :click, :right, wid)

          3 ->
            Input.send_input(:mouse, :down, :left, wid)
            Input.send_input(:mouse, :down, :right, wid)
            Input.send_input(:mouse, :up, :left, wid)
            Input.send_input(:mouse, :up, :right, wid)

          _ ->
            Logger.warn("unknown click #{inspect(click)}")
            :err
        end
    end
  end

  def throw_nade(nade) do
    Logger.debug("Throw nade")

    cond do
      nade.walk > 0 ->
        move_throw(nade.walk, nade.jump, nade.lmouse, nade.rmouse, true, nade.direction)

      nade.run > 0 ->
        move_throw(nade.run, nade.jump, nade.lmouse, nade.rmouse, false, nade.direction)

      nade.jump ->
        move_throw(0, true, nade.lmouse, nade.rmouse, false, nade.direction)

      true ->
        move_throw(0, false, nade.lmouse, nade.rmouse, false, nade.direction)
    end
  end

  def start_link(_ \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: Movement)
  end

  def init(:ok) do
    # open the log file and set the pointer to the end so that we only grab
    # new log messages
    # GenServer.call(Player, {:approach, %Location{alpha: -41, beta: 108}})
    {:ok, %{apmu: 0.022}}
  end

  def handle_call({:sensitivity, s}, _from, state) do
    Logger.debug("Updating apmu with sensitivity #{s}")
    state = Map.put(state, :apmu, 0.022 * s)
    {:reply, :ok, state}
  end

  def handle_call(:apmu, _from, state) do
    Logger.debug("Getting apmu")
    Map.get(state, :apmu)
    {:reply, Map.get(state, :apmu), state}
  end

  def handle_info({:approach, l}, state) do
    Logger.debug("Approach location (#{l.alpha}, #{l.beta})")
    approach(l, Map.get(state, :apmu))
    {:noreply, state}
  end

  def handle_info(:approach_position_test, state) do
    # approach_position(Nade.closest.location)
    l = Nade.closest().location
    approach_position(l, Map.get(state, :apmu))
    Input.type("t", Input.is_active())
    Input.type("h", Input.is_active())
    {:noreply, state}
  end

  def handle_info({:approach_position, l}, state) do
    Logger.debug("Approach position (#{l.x}, #{l.y})")
    approach_position(l, Map.get(state, :apmu))
    {:noreply, state}
  end

  def handle_info({:pronade, nade}, state) do
    approach(nade.location, Map.get(state, :apmu))
    throw_nade(nade)
    {:noreply, state}
  end

  def handle_info(:pronade, state) do
    nade = Nade.closest()
    approach(nade.location, Map.get(state, :apmu))
    throw_nade(nade)
    {:noreply, state}
  end

  def handle_info(:poll, state) do
    case Input.is_active() do
      false ->
        :err

      true ->
        Input.type("/")

      wid ->
        Input.type("/", wid)
    end

    poll()
    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.warn("Unwanted message #{inspect(msg)}")
    {:noreply, state}
  end

  defp poll(),
    do: Process.send_after(self(), :poll, 250)
end
