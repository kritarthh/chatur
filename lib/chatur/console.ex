defmodule Console do
  require Logger

  @exec_file "/tmp/say.cfg"
  @exec_key "p"

  def execute(command) do
    File.rm(@exec_file)
    File.write!(@exec_file, command)

    wid = String.trim(Shell.execute("xdotool search --class csgo_linux64"))
    Shell.execute("xdotool key --window #{wid} #{@exec_key}")
  end

end
