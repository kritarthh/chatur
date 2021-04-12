defmodule Input.Linux do
  require Logger

  def is_ready() do
    wid = String.trim(Shell.execute("xdotool search --class csgo_linux64"))
    if wid == "", do: false, else: wid
  end

  def get_text_command(text, wid) do
    "xdotool type --window #{wid} \"#{text}\""
  end

  def send_text(text, wid) do
    Shell.execute("xdotool", ["type", "--window", "#{wid}", "#{text}"])
  end

  def get_mouse_command(direction, button, wid) do
    case direction do
      :up ->
        "xdotool mouseup --window #{wid} #{if button == :right, do: 2, else: 1}"
      :down ->
        "xdotool mousedown --window #{wid} #{if button == :right, do: 2, else: 1}"
      :click ->
        "xdotool click --window #{wid} #{if button == :right, do: 2, else: 1}"
      _ ->
        Logger.warn("unknown direction #{inspect direction}")
    end
  end

  def send_mouse(direction, button, wid) do
    case direction do
      :up ->
        Shell.execute("xdotool mouseup --window #{wid} #{if button == :right, do: 2, else: 1}")
      :down ->
        Shell.execute("xdotool mousedown --window #{wid} #{if button == :right, do: 2, else: 1}")
      :click ->
        Shell.execute("xdotool click --window #{wid} #{if button == :right, do: 2, else: 1}")
      _ ->
        Logger.warn("unknown direction #{inspect direction}")
    end
  end

  def get_key_command(direction, key, wid) do
    case direction do
      :down ->
        "xdotool keydown --window #{wid} \"#{key}\""
      :up ->
        "xdotool keyup --window #{wid} \"#{key}\""
      :click ->
        "xdotool key --window #{wid} \"#{key}\""
      _ ->
        Logger.warn("unknown direction #{inspect direction}")
    end
  end

  def send_key(direction, key, wid) do
    case direction do
      :down ->
        Shell.execute("xdotool", ["keydown", "--window", "#{wid}", "#{key}"])
      :up ->
        Shell.execute("xdotool", ["keyup", "--window", "#{wid}", "#{key}"])
      :click ->
        Shell.execute("xdotool", ["key", "--window", "#{wid}", "#{key}"])
      _ ->
        Logger.warn("unknown direction #{inspect direction}")
    end
  end

  def format(xspacey_list) do
    xspacey_list
    |> Enum.map(fn x -> "#{File.cwd!}/external/humanmouse.bin -r #{Enum.at(["-a", "-f"], Enum.random(0..1))} -x #{String.replace(x, " ", " -y ")}" end)
  end

  def get_tmp_file() do
    "/tmp/chatur.movement.commands"
  end

  def execute_file(filename) do
    Shell.execute("bash #{filename}")
  end

  def execute_bin(command) do
    Shell.execute("#{command}")
  end
end
