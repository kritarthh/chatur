defmodule CrossPlatformInput do
  require Logger
  defmacro __using__(_) do
    case :os.type do
      {:win32, _} ->
        quote do
          @input_handler_command "external/mouse.exe"
          import Input.Windows
        end
      {:unix, :linux} ->
        quote do
          @input_handler_command "external/mouse.sh"
          import Input.Linux
        end
      _ ->
        Logger.error("Unsupported platform")
        :err
    end
  end
end

defmodule InputPort do
  use GenServer
  require Logger

  # GenServer API
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    Process.flag(:trap_exit, true)
    Logger.info("starting #{Input.command()}")

    port = Port.open({:spawn, Input.command()}, [:binary, :exit_status])
    Port.monitor(port)

    {:ok, %{port: port, latest_output: nil, exit_status: nil} }
  end

  defp kill() do
    Process.exit(self(), :kill)
  end

  def terminate(reason, %{port: port} = state) do
    Logger.info "** TERMINATE: #{inspect reason}. This is the last chance to clean up after this process."
    Logger.info "Final state: #{inspect state}"

    port_info = Port.info(port)
    os_pid = port_info[:os_pid]

    Logger.warn "Orphaned OS process: #{os_pid}"
    :normal
  end

  def execute_command(command) do
    send(InputPort, {:command, command, self()})
    receive do
      msg -> msg
    end
  end

  def handle_info({:command, command, pid}, %{port: port} = state) do
    Port.command(port, command<>"\n")
    receive do
      {_, {:data, "ok\n"}} ->
        send(pid, :ok)
        {:noreply, state}
      {_, {:data, err}} ->
        send(pid, err)
        {:noreply, state}
      after 1_000 ->
        Logger.warn("timed out waiting for command")
        send(pid, :err)
        {:noreply, state}
    end
  end

  # This callback handles data incoming from the command's STDOUT
  def handle_info({port, {:data, text_line}}, %{port: port} = state) do
    Logger.info "Data: #{inspect text_line}"
    {:noreply, %{state | latest_output: String.trim(text_line)}}
  end

  # This callback tells us when the process exits
  def handle_info({port, {:exit_status, status}}, %{port: port} = state) do
    Logger.info "Port exit: :exit_status: #{status}"

    new_state = %{state | exit_status: status}

    {:noreply, new_state}
  end

  def handle_info({:DOWN, _ref, :port, port, :normal}, state) do
    Logger.info "Handled :DOWN message from port: #{inspect port}"
    {:noreply, state}
  end

  def handle_info({:EXIT, _port, :normal}, state) do
    Logger.info "handle_info: EXIT"
    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.info "Unhandled message: #{inspect msg}"
    {:noreply, state}
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
      :mouse ->
        get_mouse_command(direction, data, wid)
        |> InputPort.execute_command()
      :key ->
        get_key_command(direction, data, wid)
        |> InputPort.execute_command()
      _ -> Logger.warn("unknown input type #{inspect type}")
    end
  end

  def type(text, wid \\ nil) do
    get_text_command(text, wid)
    |> InputPort.execute_command()
  end

  def mouse_format(xspacey_list) do
    format(xspacey_list)
  end

  def execute_commands(command_list) do
    command_list
    |> Enum.each(fn x -> InputPort.execute_command(x) end)
  end

  def command() do
    @input_handler_command
  end
end
