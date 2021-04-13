defmodule CrossPlatform.Console do
  require Logger
  defmacro __using__(_) do
    case :os.type do
      {:win32, _} ->
        quote do
          @exec_file "Z:/say.cfg"
        end
      {:unix, :linux} ->
        quote do
          @exec_file "/tmp/say.cfg"
        end
      ost ->
        Logger.error("Unsupported platform #{inspect ost}")
        :err
    end
  end
end

defmodule Console do
  use CrossPlatform.Console
  require Logger
  @exec_key "p"

  def execute(command) do
    File.rm(@exec_file)
    File.write!(@exec_file, command)
    case Input.is_active() do
      false -> :err
      wid ->
        Logger.debug("executing \"#{command}\"")
        Input.type(@exec_key, wid)
        Process.sleep(10)
    end
  end

end


