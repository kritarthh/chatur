defmodule Movement do
  use GenServer

  require Logger
  require Integer

  @max_moves 1000
  @apmu 0.013750

  defp get_random_string(length) do
    1..length
    |> Enum.reduce([], fn(_, acc) -> [Enum.random(String.split("abcdefghijklmnopqrstuvwxyz", "")) | acc] end)
    |> Enum.join("")
  end

  # tmp_file = "/tmp/#{get_random_string(10)}"

  defp execute(command_list) when length(command_list) > 2 do
    commands = command_list
    |> Enum.map(fn xy -> Input.mouse_format(xy) end)
    |> Enum.join("\n")
    Input.execute_commands(commands)
  end

  defp execute(command_list) when length(command_list) < 3 do
    command_list
    |> Enum.each(fn c -> Shell.execute(Input.mouse_format(c)) end)
  end


  defp get_moves(x, y) do
    lx = Enum.to_list 0..round(x)
    step = if x == 0, do: 1, else: y/x
    ly = Enum.map(lx, &(round(&1 * step)))

    Enum.zip(lx, ly)
    |> Enum.take_every(round((abs(x)/@max_moves)+1))
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [{x1, y1}, {x2, y2}] -> {x2 - x1, y2 - y1} end)
  end

  def move(x, y) when abs(x) >= abs(y) do
    Logger.debug("Moving mouse to (#{x},#{y}) relatively")
    list = get_moves(x, y)
    |> Enum.reduce([], fn ({x, y}, acc) -> ["#{x} #{y}" | acc] end)
    execute(list)
  end

  def move(x, y) when abs(x) < abs(y) do
    Logger.debug("Moving mouse to (#{y},#{x}) relatively")
    list = get_moves(y, x)
    |> Enum.reduce([], fn ({y, x}, acc) -> ["#{x} #{y}" | acc] end)
    execute(list)
  end

  def kill() do
    case Process.whereis(Movement) do
      nil -> :ok
      pid -> Process.exit(pid, :kill)
    end
  end

  defp sign(n) when n < 0, do: -1
  defp sign(n) when n >= 0, do: 1

  def approach(l, r \\ 4, mr \\ 8192) do
    cl = Player.getpos()
    Logger.debug("Approaching (#{l.alpha}, #{l.beta}, #{l.gamma}) from (#{cl.alpha}, #{cl.beta}, #{cl.gamma})")

    dx = l.beta - cl.beta
    dy = l.alpha - cl.alpha

    # rdx = (r * :math.pow(dx, 2) * sign(dx))
    # rdy = (r * :math.pow(dy, 2) * sign(dy))

    rdx = dx / @apmu
    rdy = dy / @apmu

    ratex = if abs(rdx) < 0.5, do: sign(rdx), else: if abs(rdx) > mr, do: sign(rdx) * mr, else: round(rdx)
    ratey = if abs(rdy) < 0.5, do: sign(rdy), else: if abs(rdy) > mr, do: sign(rdy) * mr, else: round(rdy)

    cond do
      abs(dx) <= 0.02 && abs(dy) <= 0.02 ->
        nil
      dx != 0 || dy != 0 ->
        move(-ratex, ratey)
        approach(l)
    end
  end

  def jump() do
    case Input.is_active() do
      false -> :err
      true -> Input.type(" ")
      wid -> Input.type(" ", wid)
    end
  end

  def jump_throw() do
    case Input.is_active() do
      false -> :err
      wid ->
        Input.send_input(:mouse, :down, :left, wid)
        Process.sleep(100)
        Input.send_input(:mouse, :up, :left, wid)
        Input.type(" ", wid)
    end
  end

  def walk_jump_throw(duration \\ 100) do
    case Input.is_active() do
      false -> :err
      wid ->
        Input.send_input(:mouse, :down, :left, wid)
        Process.sleep(100)
        Input.send_input(:key, :down, "W", wid)
        Process.sleep(duration)
        Input.send_input(:mouse, :up, :left, wid)
        Input.type(" ", wid)
        Input.send_input(:key, :up, "W", wid)
    end
  end

  def run_jump_throw(duration \\ 100) do
    case Input.is_active() do
      false -> :err
      wid ->
        Input.send_input(:mouse, :down, :left, wid)
        Process.sleep(100)
        Input.send_input(:key, :down, "w", wid)
        Process.sleep(duration)
        Input.send_input(:mouse, :up, :left, wid)
        Input.type(" ", wid)
        Input.send_input(:key, :up, "w", wid)
    end
  end

  def walk(duration \\ 100) do
    case Input.is_active() do
      false -> :err
      wid ->
        Input.send_input(:key, :down, "W", wid)
        Process.sleep(duration)
        Input.send_input(:key, :up, "W", wid)
    end
  end

  def run(duration \\ 100) do
    case Input.is_active() do
      false -> :err
      wid ->
        Input.send_input(:key, :down, "w", wid)
        Process.sleep(duration)
        Input.send_input(:key, :up, "w", wid)
    end
  end

  def fire(click \\ 1) do
    case Input.is_active() do
      false -> :err
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
            Logger.warn("unknown click #{inspect click}")
            :err
        end
    end
  end

  def throw_nade(nade) do
    Logger.debug("Throw nade")
    cond do
      nade.jump ->
        cond do
          nade.walk > 0 -> walk_jump_throw(nade.walk)
          nade.run > 0 -> run_jump_throw(nade.run)
          true -> jump_throw()
        end
      nade.lmouse -> fire(1)
      nade.rmouse -> fire(2)
      nade.lmouse && nade.rmouse ->
        fire(3)
      true -> fire()
    end
  end

  def start_link(_ \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: Movement)
  end

  def init(:ok) do
    # open the log file and set the pointer to the end so that we only grab
    # new log messages
    # GenServer.call(Player, {:approach, %Location{alpha: -41, beta: 108}})
    {:ok, %{}}
  end

  def handle_info({:approach, l}, state) do
    Logger.debug("Approach location (#{l.alpha}, #{l.beta})")
    approach(l)
    {:noreply, state}
  end

  def handle_info({:pronade, nade}, state) do
    approach(nade.location)
    throw_nade(nade)
    {:noreply, state}
  end

  def handle_info(:pronade, state) do
    nade = Nade.closest
    approach(nade.location)
    throw_nade(nade)
    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.warn("Unwanted message #{msg}")
    {:noreply, state}
  end


end
