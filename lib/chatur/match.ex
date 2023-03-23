defmodule Match do
  require Logger

  @accept_button 0.4

  def screen() do
    [width | [height]] =
      Shell.execute("xrandr")
      |> String.split("\n")
      |> Enum.filter(&String.contains?(&1, " connected "))
      |> Enum.at(0)
      |> String.split(" ")
      |> Enum.at(2)
      |> String.split("+")
      |> Enum.at(0)
      |> String.split("x")
      |> Enum.map(&String.to_integer(&1))

    Logger.debug("screen size is #{width} by #{height}")
    Logger.debug("center is #{div(width, 2)} #{trunc(height*@accept_button)}")
    "#{div(width, 2)} #{trunc(height*@accept_button)}"
  end

  def screen() do
    [width | [height]] =
      Shell.execute("wmic path Win32_VideoController get VideoModeDescription,CurrentVerticalResolution,CurrentHorizontalResolution /format:value")
      |> String.split("\n")
      |> Enum.filter(&String.contains?(&1, " connected "))
      |> Enum.at(0)
      |> String.split(" ")
      |> Enum.at(3)
      |> String.split("+")
      |> Enum.at(0)
      |> String.split("x")
      |> Enum.map(&String.to_integer(&1))

    Logger.debug("screen size is #{width} by #{height}")
    Logger.debug("Accept button should be at #{div(width, 2)} #{trunc(height*@accept_button)}")
    "#{div(width, 2)} #{trunc(height*@accept_button)}"
  end

  def accept() do
    case Input.is_active() do
      false -> :err
      true ->
        Process.sleep(5000)
        Input.send_input(:mouse, :move, "#{screen()}")
        Input.send_input(:mouse, :click, :left)
      wid ->
        Process.sleep(5000)
        Input.send_input(:mouse, :move, "#{screen()}", wid)
        Input.send_input(:mouse, :click, :left, wid)
    end
  end

  def players() do
  end

  def binds() do
  end

  def spam_key() do
    case Input.is_active() do
      false ->
        :err

      true ->
        Input.type("/")

      wid ->
        Input.type("/", wid)
    end

    Process.sleep(100)
    spam_key()
  end
end
