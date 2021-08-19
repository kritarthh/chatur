defmodule Startup do
  require Logger

  def wait_for_ramdisk() do
    Logger.info("waiting for ramdisk")
    if not File.exists?("R:/") do
      Process.sleep(1000)
      wait_for_ramdisk()
    end
  end

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
      {:win32, _} ->
        priv = Application.app_dir(Application.get_application(__MODULE__), "priv")
        csgo_cfg = "C:/Program Files (x86)/Steam/steamapps/common/Counter-Strike Global Offensive/csgo/cfg"
        File.mkdir("#{csgo_cfg}/chatur")
        File.copy("#{priv}/startup.cfg", "#{csgo_cfg}/chatur.cfg")
        File.copy("#{priv}/nadeking.cfg", "#{csgo_cfg}/nadeking.cfg")
        Shell.execute("#{priv}/ramdisk.bat")
        wait_for_ramdisk()
        # its safe to modify exec file anytime
        File.rm("#{csgo_cfg}/chatur/say.cfg")
        File.touch(Console.get_exec_file())
        Shell.execute("cmd.exe", ["/c", "mklink", "#{csgo_cfg}/chatur/say.cfg", "R:\\say.cfg"])
        if not File.exists?("#{csgo_cfg}/chatur/console.log") do
          # we don't want to touch this if already in use by csgo
          File.touch(LogReader.get_log_file())
          Shell.execute("cmd.exe", ["/c", "mklink", "#{csgo_cfg}/chatur/console.log", "R:\\console.log"])
          Logger.warn("Please exec chatur in csgo console, followed by ; (semicolon) when alive in map")
        end
      _ -> nil
    end
  end
end

# https://www.microsoft.com/en-in/download/details.aspx?id=40784
