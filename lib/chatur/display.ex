defmodule Display do
  require Logger

  def write(text) do
    Console.execute("developer 0")
    Console.execute("con_filter_enable 2")
    Console.execute(~s/con_filter_text ""/)
    Process.sleep(250)
    Console.execute("developer 1")
    for line <- String.split(text, ":") do
      Console.execute(~s/echo "#{line}"/)
    end
    Console.execute(~s/echo "-------------------------------------------------"/)
    Console.execute(~s/con_filter_text "!@#nevermatches#@!"/)
  end
end
