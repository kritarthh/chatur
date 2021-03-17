defmodule Console do
  @exec_file "/tmp/say.cfg"
  @exec_key "p"

  def execute(command) do
    File.rm(@exec_file)
    File.write!(@exec_file, command)
    case Input.is_active() do
      false -> :err
      wid -> Input.type(@exec_key, wid)
    end
  end

end


