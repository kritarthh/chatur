defmodule CrossPlatform.Reader do
  require Logger

  defmacro __using__(_) do
    case :os.type() do
      {:win32, _} ->
        quote do
          @log_file "Z:/console.log"
        end

      {:unix, :linux} ->
        quote do
          @log_file "/tmp/console.log"
        end

      ost ->
        Logger.error("Unsupported platform #{inspect(ost)}")
        :err
    end
  end
end

defmodule LogReader do
  use GenServer
  use CrossPlatform.Reader

  require Logger

  # 5 seconds
  @poll_interval 500

  def start_link(_ \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: LogReader)
  end

  def init(:ok) do
    # open the log file and set the pointer to the end so that we only grab
    # new log messages
    {:ok, fp} = File.open(@log_file, [:read])
    :file.position(fp, :eof)
    poll()
    {:ok, fp}
  end

  def handle_info({:read_until, regex}, fp) do
    fp |> read_til(regex) |> send_to_channel
    {:noreply, fp}
  end

  def handle_info(:read_log_lines, fp) do
    # consume any new log lines and pass them off the channel
    fp |> read_til_eof |> send_to_channel
    poll()
    {:noreply, fp}
  end

  def read_til(fp, regex) do
    case read_til_eof(fp) do
      [] ->
        Process.sleep(100)
        read_til(fp, regex)

      lines ->
        filtered_lines =
          lines
          |> Enum.filter(fn line -> not String.match?(line, regex) end)

        send_to_channel(filtered_lines)

        case Enum.filter(lines, fn line -> String.match?(line, regex) end) do
          [] -> read_til(fp, regex)
          sm -> sm
        end
    end
  end

  def read_til_eof(fp),
    do: read_til_eof(IO.binread(fp, :line), fp, [])

  def read_til_eof(:eof, _fp, buffer), do: buffer

  def read_til_eof(line, fp, buffer),
    do: read_til_eof(IO.binread(fp, :line), fp, buffer ++ [line])

  # this could be handing off the new lines to some service or sending directly
  # to the channel or whatever
  def send_to_channel([]), do: :ok

  def send_to_channel(lines) do
    for line <- lines do
      GenServer.cast(LogDispatcher, {:log_line, String.trim_trailing(line)})
    end
  end

  defp poll(),
    do: Process.send_after(self(), :read_log_lines, @poll_interval)

  def get_log_file() do
    @log_file
  end
end
