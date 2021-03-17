defmodule Input.Linux do
  require Logger

  def is_ready() do
    wid = String.trim(Shell.execute("xdotool search --class csgo_linux64"))
    if wid == "", do: false, else: wid
  end

  def send_text(text, wid) do
    Shell.execute("xdotool", ["type", "--window", "#{wid}", "#{text}"])
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

  def format(xspacey) do
    "xdotool mousemove_relative --sync -- #{xspacey}"
  end

  def get_tmp_file() do
    "/tmp/chatur.movement.commands"
  end

  def execute_file(filename) do
    Shell.execute("bash #{filename}")
  end
end
