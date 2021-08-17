defmodule Input.Windows do
  require Logger

  def is_ready() do
    "csgo::Counter-Strike: Global Offensive" ==
      String.trim(
        Shell.execute(
          "#{Application.app_dir(Application.get_application(__MODULE__), "priv")}/external/window.exe"
        )
      )
  end

  def get_text_command(text, wid) do
    "mouse.exe type \"#{text}\""
  end

  def send_text(text, _) do
    Shell.execute("cmd.exe", ["/c", "mouse.exe", "type", "#{text}"])
  end

  def get_mouse_command(direction, button, _) do
    case direction do
      :up ->
        "mouse.exe #{if button == :right, do: "right"}release"

      :down ->
        "mouse.exe #{if button == :right, do: "right"}press"

      :click ->
        "mouse.exe #{if button == :right, do: "right"}click"

      _ ->
        Logger.warn("unknown direction #{inspect(direction)}")
        ""
    end
  end

  def send_mouse(direction, button, _) do
    case direction do
      :up ->
        Shell.execute("cmd.exe /c mouse.exe #{if button == :right, do: "right"}release")

      :down ->
        Shell.execute("cmd.exe /c mouse.exe #{if button == :right, do: "right"}press")

      :click ->
        Shell.execute("cmd.exe /c mouse.exe #{if button == :right, do: "right"}click")

      :move ->
        Shell.execute("cmd.exe /c mouse.exe moveTo")

      _ ->
        Logger.warn("unknown direction #{inspect(direction)}")
    end
  end

  def get_key_command(direction, key, wid) do
    case direction do
      :up ->
        "mouse.exe key up \"#{key}\""

      :down ->
        "mouse.exe key down \"#{key}\""

      :click ->
        "mouse.exe key down \"#{key}\"\nmouse.exe key up \"#{key}\""

      _ ->
        Logger.warn("unknown direction #{inspect(direction)}")
        ""
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
        Logger.warn("unknown direction #{inspect(direction)}")
    end
  end

  def format(xspacey_list) do
    xspacey_list
    |> Enum.map(fn x ->
      "#{Application.app_dir(Application.get_application(__MODULE__), "priv")}/external/humanmouse.exe -r -a -x #{String.replace(x, " ", " -y ")}"
    end)

    # movements = xspacey_list
    # |> Enum.map(fn x -> String.replace(x, " ", "x") end)
    # |> Enum.join(",")
    # ["mouse.exe moveBy #{movements}"]
  end

  def get_tmp_file() do
    "C:/chatur.movement.commands.bat"
  end

  def execute_file(filename) do
    Shell.execute("cmd.exe /c #{filename}")
  end

  def execute_bin(command) do
    Shell.execute("#{command}")
  end

  def link() do
    Shell.execute(
      "cmd.exe",
      [
        "/c",
        "mklink",
        "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\cfg\chatur\console.log",
        "C:\console.log"
      ]
    )
  end
end
