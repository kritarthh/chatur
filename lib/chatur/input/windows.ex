defmodule Input.Windows do
  require Logger

  def is_ready() do
    "csgo::Counter-Strike: Global Offensive" == String.trim(Shell.execute("cmd.exe /c window.exe"))
  end

  def send_text(text, _) do
    Shell.execute("cmd.exe", ["/c", "mouse.exe", "type", "#{text}"])
  end

  def send_mouse(direction, button, _) do
    case direction do
      :up ->
        Shell.execute("cmd.exe /c mouse.exe #{if button == :right, do: "right"}release")
      :down ->
        Shell.execute("cmd.exe /c mouse.exe #{if button == :right, do: "right"}press")
      :click ->
        Shell.execute("cmd.exe /c mouse.exe #{if button == :right, do: "right"}click")
      _ ->
        Logger.warn("unknown direction #{inspect direction}")
    end
  end

  def send_key(direction, key, wid) do
    case direction do
      :up ->
        Shell.execute("cmd.exe", ["/c", "mouse.exe", "key", "up", "#{key}"])
      :down ->
        Shell.execute("cmd.exe", ["/c", "mouse.exe", "key", "down", "#{key}"])
      :click ->
        send_key(:down, key, wid)
        send_key(:up, key, wid)
      _ ->
        Logger.warn("unknown direction #{inspect direction}")
    end
  end

  def format(xspacey) do
    "mouse.exe moveBy #{String.replace(xspacey, " ", "x")}"
  end

  def get_tmp_file() do
    "Z:/chatur.movement.commands"
  end

  def execute_file(filename) do
    Shell.execute("cmd.exe /c #{filename}")
  end

  def link() do
    Shell.execute("cmd.exe",
      ["/c",
       "mklink",
       "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\cfg\chatur\console.log",
       "Z:\chatur_console.log"])
  end
end
