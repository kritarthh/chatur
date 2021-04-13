defmodule Nades.Dust2 do
  def store() do
    [
      %Nade{
        map: "de_dust2",
        code: "d2-t-xbox",
        dest: "x box",
        location: Location.parse("setpos -299.968750 -1163.968750 141.760681;setang -17.022409 90.258972 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_dust2",
        code: "d2-t-ctl",
        dest: "ct long",
        location: Location.parse("setpos -608.019531 -1063.975342 193.309357;setang -17.5 70.2 0.000000"),
        jump: true,
        run: 275
      },
      %Nade{
        map: "de_dust2",
        code: "d2-t-as",
        dest: "as",
        location: Location.parse("setpos -608.019531 -1063.975342 193.309357;setang -13.0 69.8 0.000000"),
        jump: true,
        run: 500
      },
      %Nade{
        map: "de_dust2",
        code: "d2-t-as",
        dest: "as",
        location: Location.parse("setpos -608.019531 -1063.975342 193.309357;setang -15.0 70.3 0.000000"),
        jump: true,
        walk: 750
      },
      %Nade{
        map: "de_dust2",
        code: "d2-t-ctl",
        dest: "ct long",
        location: Location.parse("setpos -608.019531 -1063.975342 193.309357;setang -16.0 70.3 0.000000"),
        jump: true,
        walk: 800
      },
      %Nade{
        map: "de_dust2",
        code: "d2-tcar-bd",
        dest: "b doors",
        location: Location.parse("setpos 758.811523 -395.982880 132.093811;setang -27.5 134.0 0.000000"),
        jump: true,
        direction: "wd",
        run: 785
      }
    ]
  end
end
