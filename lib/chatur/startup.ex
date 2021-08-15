defmodule Startup do
  require Logger
  def make_links() do
    case :os.type do
      {:unix, _} ->
        home = Shell.bash("echo $HOME") |> String.trim_trailing("\n")

        # File.rm_rf(Console.get_exec_file())
        # File.rm_rf("#{home}/.steam/steam/steamapps/common/Counter-Strike Global Offensive/csgo/cfg/chatur/say.cfg")
        File.touch(Console.get_exec_file())

        # File.rm_rf(LogReader.get_log_file())
        # File.rm_rf("#{home}/.steam/steam/steamapps/common/Counter-Strike Global Offensive/csgo/cfg/chatur/console.log")
        File.touch(LogReader.get_log_file())

        _ = Shell.bash("ln -s #{Console.get_exec_file()} #{home}/.steam/steam/steamapps/common/Counter-Strike\\ Global\\ Offensive/csgo/cfg/chatur/say.cfg")
        _ = Shell.bash("ln -s #{LogReader.get_log_file()} #{home}/.steam/steam/steamapps/common/Counter-Strike\\ Global\\ Offensive/csgo/cfg/chatur/console.log")

        config_path = for d <- (Shell.execute("ls #{home}/.steam/steam/userdata/")
        |> String.split("\n")
        |> Enum.filter(&(&1 != ""))
              |> Enum.map(&("#{home}/.steam/steam/userdata/"<>&1))
            ) do
            if File.exists?(d<>"/config/localconfig.vdf") do
              d<>"/config/localconfig.vdf"
            else
              ""
            end
        end
        |> Enum.reduce("", fn x, acc -> x<>acc end)

        if (File.read!(config_path) |> String.contains?("chatur/startup.cfg")) do
          Logger.info("Launch option found.")
        else
          Logger.error("Launch option not found. Please set +exec chatur/startup.cfg in your csgo launch options in Steam and then restart chatur")
        end
    end
  end
end
