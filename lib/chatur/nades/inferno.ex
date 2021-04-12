defmodule Nades.Inferno do
  def store() do
    [
      %Nade{
        map: "de_inferno",
        code: "inf-brg-bcof",
        dest: "b coffin",
        location: Location.parse("setpos -454.968750 -270.971863 284.093811;setang -11.0 75.0 0.000000"),
        jump: true,
        run: 250
      },
      %Nade{
        map: "de_inferno",
        code: "inf-undbr-bcof",
        dest: "b coffin",
        location: Location.parse("setpos -144.031250 -268.968750 102.648041;setang -23.659863 76.378838 0.000000"),
        jump: true,
        run: 200
      },
      %Nade{
        map: "de_inferno",
        code: "inf-tsaltmid-bcof",
        dest: "b ct",
        location: Location.parse("setpos -869.031250 -464.968750 72.093811;setang -26.491758 62.975346 0.000000"),
        jump: true,
        run: 500
      },
      %Nade{
        map: "de_inferno",
        code: "inf-altmid-arch",
        dest: "arch",
        location: Location.parse("setpos 95.968750 -207.968750 112.754631;setang -13.992747 29.578848 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_inferno",
        code: "inf-altmid-lib",
        dest: "lib",
        location: Location.parse("setpos 721.011841 48.992817 158.251434;setang -18.823704 39.840591 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_inferno",
        code: "inf-pit-mid",
        dest: "mid",
        location: Location.parse("setpos 2643.648438 -337.031250 154.831360;setang -19.813507 144.175995 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_inferno",
        code: "inf-pit-mid",
        dest: "mid",
        location: Location.parse("setpos 2633.970947 -473.968750 153.048431;setang -19.345963 140.197067 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_inferno",
        code: "inf-tramp-as",
        dest: "ashort",
        location: Location.parse("setpos -446.968750 909.968750 38.227348;setang -27.362434 -17.520075 0.000000"),
        walk: 1250,
        jump: true
      },
      %Nade{
        map: "de_inferno",
        code: "inf-tramp-apal",
        dest: "apalace",
        location: Location.parse("setpos -446.968750 909.968750 38.227348;setang -20.390762 -18.630499 0.000000"),
        run: 310,
        jump: true
      },
      %Nade{
        map: "de_inferno",
        code: "inf-ct-ban",
        dest: "banana",
        location: Location.parse("setpos 1128.031250 2643.031250 198.557877;setang -4.949471 126.186295 0.000000")
      },
      %Nade{
        map: "de_inferno",
        code: "inf-altmid-asboil",
        dest: "ashort boiler",
        location: Location.parse("setpos 95.968750 -207.968750 112.754631;setang -14.437306 18.718454 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_inferno",
        code: "inf-altmid-apal",
        dest: "a palace",
        location: Location.parse("setpos 56.020046 -36.031250 107.337509;setang -18.177385 -5.269500 0.000000"),
        jump: true
      }
   ]
  end
end
