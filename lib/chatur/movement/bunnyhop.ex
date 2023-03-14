defmodule Movement.BunnyHop do
  use GenServer

  require Logger

  @timing 15

  def start_link(_ \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: BunnyHop)
  end

  def init(:ok) do
    {:ok, false}
  end

  def start() do
    send(BunnyHop, :start)
  end

  def stop() do
    send(BunnyHop, :stop)
  end

  def toggle() do
    send(BunnyHop, :toggle)
  end

  def handle_info(:start, state) do
    if not state do
      poll()
    end
    {:noreply, true}
  end

  def handle_info(:toggle, state) do
    if not state do
      poll()
      # start()
    end
    {:noreply, not state}
  end

  def handle_info(:stop, _state) do
    {:noreply, false}
  end

  def handle_info(:hop, state) do
    if state do
      Movement.jump()
      Movement.jump()
      Movement.jump()
      Movement.jump()
      Movement.jump()
      Movement.jump()
      Movement.jump()
      Movement.jump()
      Movement.jump()
      Movement.jump()
      poll()
    end
    {:noreply, state}
  end

  defp poll(),
    do: Process.send_after(self(), :hop, 15)

end
