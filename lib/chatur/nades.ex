defmodule Nade do
  require Logger

  defstruct [
    map: "",
    code: "",
    src: "",
    dest: "",
    description: "",
    location: %Location{},
    direction: "w",
    run: 0,
    walk: 0,
    jump: false,
    crouch: false,
    lmouse: true,
    rmouse: false,
    tolerance: 1
  ]

  defimpl String.Chars, for: Nade do
    def to_string(n) do
      "(#{n.map}, #{n.code}, #{n.location}) (lmouse:#{n.lmouse}, rmouse:#{n.rmouse}) (jump:#{n.jump}, walk:#{n.walk}, run:#{n.run})"
    end
  end

  @keys ["H", "J", "K", "L", "N", "M"]

  def key(k) do
    Enum.member?(@keys, k)
  end

  def keys() do
    @keys
  end

  def map_store(map) do
    case map do
      "de_inferno" -> Nades.Inferno
      "de_mirage" -> Nades.Mirage
      "de_dust2" -> Nades.Dust2
      "de_train" -> Nades.Train
      "de_overpass" -> Nades.Overpass
      _ -> Nades.NotFound
    end
  end


  def closest() do
    cpos = Player.getpos
    Logger.debug("current position is #{cpos}")
    sorted_list = map_store(Player.get_map()).nades()
    |> Enum.sort_by(
    fn nade ->
      diff = abs(nade.location.alpha - cpos.alpha) +
      abs(nade.location.beta - cpos.beta) +
      abs(nade.location.x - cpos.x) +
      abs(nade.location.y - cpos.y) +
      abs(nade.location.z - cpos.z)
      Logger.debug("diff with #{nade.code} is #{diff}")
      diff
    end
    )
    sorted_list |> Enum.each(fn i -> Logger.debug("#{i.code} - #{i.location}") end)
    nade = List.first(sorted_list)
    Logger.debug("best nade position is #{nade.location}")
    nade
  end


  def list() do
    cpos = Player.getpos
    map_store(Player.get_map()).store()
    |> Enum.filter(
    fn nade ->
      abs(nade.location.x - cpos.x) < nade.tolerance and
      abs(nade.location.y - cpos.y) < nade.tolerance and
      abs(nade.location.z - cpos.z) < nade.tolerance
    end
    )
    |> Enum.zip(@keys)
  end

  def overlay() do
    overlay_text = list()
    |> Enum.reduce("", fn {i, k}, text -> text <> ":#{k} - #{i.dest} (#{i.code})" end)
    |> String.slice(1..-1)
    text = if overlay_text == "", do: "No nades found", else: overlay_text
    Logger.info("Overlay text: #{text}")
    spawn(fn -> Shell.execute("bash", ["-c", "killall noptions 2> /dev/null ; ./external/noptions \""<>text<>"\""]) end)
    Display.write(text)
    :ok
  end

  def overlay(key) do
    case list() |> Enum.find(fn {_, x} -> x == key end)
      do
      {overlay_nade, _} ->
        Logger.debug("Overlay nade is #{overlay_nade}")
        send(Movement, {:pronade, overlay_nade})
      nil ->
        :ok
    end
  end

  def init_maps_agents(map) do
    spec = %{id: "#{inspect map}", start: {map, :start_link, []}}
    DynamicSupervisor.start_child(Nades, spec)
  end
end



defmodule Nades.Agent do
  defmacro __using__(_) do
    quote do
      use Agent
      require Logger

      # store() would be defined by modules using this
      def start_link() do
        Agent.start_link(fn -> store() end, name: __MODULE__)
      end

      def nades() do
        Agent.get(__MODULE__, & &1)
      end

      def update() do
        nades = case File.read("#{File.cwd!}/#{__MODULE__}.nades") do
          {:ok, contents} ->
            Code.eval_string(contents)
          _ ->
            Logger.warn("#{__MODULE__}.nades file not found")
            []
        end
        Agent.update(__MODULE__, store() ++ nades)
      end

    end
  end
end
