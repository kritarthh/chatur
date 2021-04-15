defmodule Nades.Dust2 do
  use Nades.Agent

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
        code: "d2-cat-bd",
        dest: "b doors",
        location: Location.parse("setpos -149.031250 1126.817627 63.601971;setang -17.695778 113.25 0.000000"),
        jump: true,
        run: 275,
        tolerance: 5
      },
      %Nade{
        map: "de_dust2",
        code: "d2-car-ald",
        dest: "a long doors",
        location: Location.parse("setpos 1770.266724 2263.968750 71.283478;setang -15.55 -126.65 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_dust2",
        code: "d2-as-ald",
        dest: "a long doors",
        location: Location.parse("setpos 417.031250 2763.968750 162.040131;setang -15.423732 -84.430885 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_dust2",
        code: "d2-al-ctmb",
        src: "a long barrel near door",
        dest: "ct mid to b",
        location: Location.parse("setpos 860.031250 790.031250 68.376801;setang -16.431044 145.423599 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_dust2",
        code: "d2-al-acar",
        dest: "a car",
        location: Location.parse("setpos 847.172424 790.031250 111.093811;setang 5.15 52.999557 0.000000"),
        jump: true,
        walk: 10
      },
      %Nade{
        map: "de_dust2",
        code: "d2-xbox-ctmb",
        src: "xbox",
        dest: "ct mid to b",
        location: Location.parse("setpos -275.031250 1345.370850 -58.664795;setang -35.840942 131.445526 0.000000")
      },
      %Nade{
        map: "de_dust2",
        code: "d2-pit-ctfar",
        src: "pit right corner",
        dest: "ct far cross",
        jump: true,
        location: Location.parse("setpos 1571.968750 201.031250 -114.864868;setang -9.688395 99.510048 0.000000")
      },
      %Nade{
        map: "de_dust2",
        code: "d2-pit-ctclose",
        src: "pit right corner",
        dest: "ct close cross",
        jump: true,
        location: Location.parse("setpos 1571.968750 201.031250 -114.864868;setang -4.862122 99.771263 0.000000")
      },
      %Nade{
        map: "de_dust2",
        code: "d2-pit-ctfar",
        src: "pit left corner",
        dest: "ct far cross",
        jump: true,
        location: Location.parse("setpos 1292.040039 201.031250 -116.689606;setang -7.254783 89.556458 0.000000")
      },
      %Nade{
        map: "de_dust2",
        code: "d2-pit-ctclose",
        src: "pit left corner",
        dest: "ct close cross",
        jump: true,
        location: Location.parse("setpos 1292.040039 201.031250 -116.689606;setang -4.614770 89.515213 0.000000")
      },
      %Nade{
        map: "de_dust2",
        code: "d2-pit-ctcenter",
        src: "pit right corner",
        dest: "ct center cross",
        jump: true,
        location: Location.parse("setpos 1571.968750 201.031250 -114.864868;setang -5.692493 99.796043 0.000000")
      },
      %Nade{
        map: "de_dust2",
        code: "d2-pit-ctcenter",
        src: "pit left corner",
        dest: "ct center cross",
        jump: true,
        location: Location.parse("setpos 1292.004272 201.031250 -116.689606;setang -5.55 89.558510 0.000000")
      },
      %Nade{
        map: "de_dust2",
        code: "d2-ald-ctcenter",
        src: "a long doors",
        dest: "ct center cross",
        run: 200,
        location: Location.parse("setpos 860.031250 790.031250 68.376785;setang -23.365307 44.820953 0.000000")
      },
      %Nade{
        map: "de_dust2",
        code: "d2-ald-ctclose",
        src: "a long doors",
        dest: "ct close cross",
        run: 100,
        location: Location.parse("setpos 860.031250 790.031250 68.376785;setang -23.365307 44.820953 0.000000")
      },
      %Nade{
        map: "de_dust2",
        code: "d2-ald-ctfar",
        src: "a long doors",
        dest: "ct far cross",
        run: 400,
        location: Location.parse("setpos 860.031250 790.031250 68.376785;setang -23.365307 44.820953 0.000000")
      },
      %Nade{
        map: "de_dust2",
        code: "d2-ald-ctspawn",
        src: "a long doors",
        dest: "ct spawn cross",
        location: Location.parse("setpos 516.031250 983.078003 65.535233;setang -52.169254 88.662766 0.000000")
      },
      %Nade{
        map: "de_dust2",
        code: "d2-ald-btunbox",
        src: "ut",
        dest: "b tunnels box",
        run: 200,
        location: Location.parse("setpos -2185.968750 1059.022095 103.864021;setang -13.008841 57.042904 0.000000")
      }
    ]
  end
end
