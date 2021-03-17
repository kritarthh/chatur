defmodule CrossPlatformInput do
  require Logger
  defmacro __using__(_) do
    case :os.type do
      {:win32, _} ->
        quote do
          import Input.Windows
        end
      {:unix, :linux} ->
        quote do
          import Input.Linux
        end
      _ ->
        Logger.error("Unsupported platform")
        :err
    end
  end
end

defmodule Input do
  require Logger
  use CrossPlatformInput

  def is_active() do
    is_ready()
  end

  def send_input(type, direction, data, wid \\ nil) do
    case type do
      :mouse -> send_mouse(direction, data, wid)
      :key -> send_key(direction, data, wid)
      _ -> Logger.warn("unknown input type #{inspect type}")
    end
  end

  def type(text, wid \\ nil) do
    send_text(text, wid)
  end

  def mouse_format(xspacey_list) do
    format(xspacey_list)
  end

  def execute_commands(command_list) do
    tmp_file = get_tmp_file()
    File.rm_rf(tmp_file)
    File.write!(tmp_file, Enum.join(command_list, "\n"))
    execute_file(tmp_file)
  end
end
