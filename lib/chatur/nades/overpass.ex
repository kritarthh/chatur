defmodule Nades.Overpass do
  def store() do
    [
      %Nade{
        map: "de_overpass",
        code: "op-al-bheav",
        dest: "b heavan",
        location: Location.parse("setpos -3556.512695 -2517.221436 540.466919;setang -17.4 56.1 0.000000"),
        jump: true,
        run: 320
      },
      %Nade{
        map: "de_overpass",
        code: "op-foun-bheav",
        dest: "b heavan",
        location: Location.parse("setpos -2346.006104 -1632.037842 548.530090;setang -4.289742 71.281219 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_overpass",
        code: "op-as-bheav",
        dest: "b heavan",
        location: Location.parse("setpos -2178.031250 -1151.968750 462.025208;setang -26.070181 71.414200 0.000000"),
        jump: false
      },
      %Nade{
        map: "de_overpass",
        code: "op-party-bs",
        dest: "b short",
        location: Location.parse("setpos -3171.972900 -1757.984863 588.791809;setang -4.9 49.25 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_overpass",
        code: "op-al-bs",
        dest: "b short",
        location: Location.parse("setpos -3959.971191 -1672.002808 575.224792;setang -8.772255 29.379967 0.000000"),
        jump: true,
        walk: 500
      },
      %Nade{
        map: "de_overpass",
        code: "op-ct-bmons",
        dest: "b monster",
        location: Location.parse("setpos -2116.414795 993.172424 544.093811;setang -22.866987 -50.521404 0.000000"),
        jump: true
      }
    ]
  end
end
