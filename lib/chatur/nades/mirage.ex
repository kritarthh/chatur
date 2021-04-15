defmodule Nades.Mirage do
  use Nades.Agent

  def store() do
    [
      %Nade{
        map: "de_mirage",
        code: "mi-t-midwin",
        dest: "nest",
        location: Location.parse("setpos 1422.968750 70.990822 -48.840103;setang -16.183821 -165.854309 0.000000"),
        jump: true,
        walk: 300
      },
      %Nade{
        map: "de_mirage",
        code: "mi-t-midwin",
        dest: "nest",
        location: Location.parse("setpos 1383.830566 70.968750 -103.906189;setang -24.213606 -165.895554 0.000000"),
        jump: true,
        walk: 190
      },
      %Nade{
        map: "de_mirage",
        code: "mi-t-midwin",
        dest: "nest",
        location: Location.parse("setpos 1422.968750 34.830582 -103.906189;setang -21.792624 -166.882004 0.000000"),
        jump: true,
        walk: 190
      },
      %Nade{
        map: "de_mirage",
        code: "mi-t-bs",
        dest: "b short",
        location: Location.parse("setpos 1422.993896 -367.968750 -103.906189;setang -42.595161 176.061630 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_mirage",
        code: "mi-t-ct",
        dest: "ct",
        location: Location.parse("setpos 1358.811523 519.977478 -194.359680;setang -43.942387 -122.5 0.000000"),
        jump: true,
        run: 450
      },
      %Nade{
        map: "de_mirage",
        code: "mi-t-topcon",
        dest: "top connector",
        location: Location.parse("setpos 1359.318848 519.994202 -194.341431;setang -41.525074 -140.808731 0.000000"),
        jump: true,
        walk: 450
      },
      %Nade{
        map: "de_mirage",
        code: "mi-t-bdoor",
        dest: "b door",
        location: Location.parse("setpos 1422.968750 -367.968750 -103.906189;setang -42.857834 177.0 0.000000"),
        jump: true,
        run: 275
      },
      %Nade{
        map: "de_mirage",
        code: "mi-t-bwin",
        dest: "b window",
        location: Location.parse("setpos 1422.949219 -367.968750 -103.906189;setang -41.4 177.6 0.000000"),
        jump: true,
        walk: 500
      },
      %Nade{
        map: "de_mirage",
        code: "mi-bbench-amain",
        dest: "a main",
        location: Location.parse("setpos -2599.987061 535.968750 -95.906189;setang -32.846397 -40.297672 0.000000"),
        jump: true,
        run: 750
      },
      %Nade{
        map: "de_mirage",
        code: "mi-bbench-apal",
        dest: "a palace",
        location: Location.parse("setpos -2599.987061 535.968750 -95.906189;setang -34.5 -44.9 0.000000"),
        jump: true,
        run: 750
      },
      %Nade{
        map: "de_mirage",
        code: "mi-ct-amain",
        dest: "a main",
        location: Location.parse("setpos -1547.980957 -2407.968750 -175.948792;setang -15.69 29.42 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_mirage",
        code: "mi-t-stairs",
        dest: "a stairs",
        location: Location.parse("setpos 1239.971313 -1128.015503 -190.052521;setang -57.966770 -166.183212 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_mirage",
        code: "mi-tmain-bs",
        dest: "b short",
        location: Location.parse("setpos 1239.968750 -1128.012939 -190.065842;setang -30.669401 157.141357 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_mirage",
        code: "mi-ct-bapps",
        dest: "b appartments",
        location: Location.parse("setpos -1547.980835 -2407.968750 -175.951965;setang -23.502520 92.261230 0.000000"),
        jump: true,
        run: 400
      },
      %Nade{
        map: "de_mirage",
        code: "mi-t-jungle",
        dest: "jungle",
        location: Location.parse("setpos 1239.968750 -1128.012939 -190.052917;setang -54.924603 -166.083939 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_mirage",
        code: "mi-amain-bsite",
        dest: "b site",
        location: Location.parse("setpos 1239.968750 -1128.012939 -190.052902;setang -41.605736 160.032394 0.000000"),
        jump: true,
        run: 300
      },
      %Nade{
        map: "de_mirage",
        code: "mi-amain-nest",
        dest: "nest",
        location: Location.parse("setpos 1239.968750 -1159.968750 -182.204575;setang -34.168858 168.307663 0.000000"),
        jump: true,
        walk: 100
      },
      %Nade{
        map: "de_mirage",
        code: "mi-amain-nest",
        dest: "nest",
        location: Location.parse("setpos 988.004395 -1243.381470 -44.906189;setang -17.028680 164.633655 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_mirage",
        code: "mi-amain-nest",
        dest: "nest",
        location: Location.parse("setpos 1127.968750 -1209.791992 -44.906189;setang -27.490086 166.705093 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_mirage",
        code: "mi-mid-ct",
        dest: "ct",
        location: Location.parse("setpos 343.301575 -621.619324 -99.367020;setang -35.816681 -116.552933 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_mirage",
        code: "mi-mid-topcon",
        dest: "top connector",
        location: Location.parse("setpos 343.301605 -621.619324 -99.367020;setang -42.357292 -150.499298 0.000000")
      },
      %Nade{
        map: "de_mirage",
        code: "mi-mid-nest",
        dest: "nest",
        location: Location.parse("setpos 343.301605 -621.619263 -99.367020;setang -31.879614 -179.983261 0.000000")
      },
      %Nade{
        map: "de_mirage",
        code: "mi-tv-bsleft",
        dest: "b site short left",
        location: Location.parse("setpos -160.024704 760.019470 -70.526001;setang -67.0 -157.0 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_mirage",
        code: "mi-mib-bsright",
        dest: "b site short right",
        location: Location.parse("setpos -160.026047 760.001953 -70.525955;setang -43.988628 -164.967834 0.000000")
      },
      %Nade{
        map: "de_mirage",
        code: "mi-tv-bsleft",
        dest: "b site short left",
        location: Location.parse("setpos -351.968750 887.968750 -60.911903;setang -68.390579 -148.230591 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_mirage",
        code: "mi-mib-bsright",
        dest: "b site short right",
        location: Location.parse("setpos -351.968750 887.968750 -60.911896;setang -71.567299 -158.183517 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_mirage",
        code: "mi-tv-bwin",
        dest: "b window",
        location: Location.parse("setpos -160.031250 887.968750 -71.265823;setang -50.377125 -146.538834 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_mirage",
        code: "mi-bench-botcon",
        dest: "bottom connector",
        location: Location.parse("setpos -2599.968750 535.997131 -95.906189;setang -31.224289 -35.344635 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_mirage",
        code: "mi-bapps-astairs",
        dest: "a stairs",
        location: Location.parse("setpos -2025.031250 849.968750 16.093811;setang -47.2 -50.5 0.000000"),
        jump: true,
        walk: 600
      },
      %Nade{
        map: "de_mirage",
        code: "mi-topmid-topcon",
        dest: "top connector",
        location: Location.parse("setpos 146.031250 -935.805847 -102.821381;setang -75.787857 -152.944916 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_mirage",
        code: "mi-topmid-astairs",
        dest: "a stairs",
        location: Location.parse("setpos 360.075470 -691.968750 -98.434219;setang -69.69 -132.310730 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_mirage",
        code: "mi-ct-amain",
        dest: "a main",
        location: Location.parse("setpos -2026.396606 -2029.968750 -235.066010;setang -12.509787 12.530984 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_mirage",
        code: "mi-ct-bs",
        dest: "b short",
        description: "bshort one way smoke from ct",
        location: Location.parse("setpos -2031.968750 -1957.019531 -236.368591;setang -26.919762 51.500401 0.000000"),
        jump: true
      },
      %Nade{
        map: "de_mirage",
        code: "mi-mib-b",
        dest: "b site short plant",
        location: Location.parse("setpos 360.075500 -691.968750 -98.434235;setang -22.260391 156.560806 0.000000"),
        jump: true
      }
    ]
  end
end
