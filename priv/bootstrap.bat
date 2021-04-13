copy startup.cfg "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\cfg\chatur\startup.cfg"

mkdir "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\cfg\chatur\"
mklink "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\cfg\chatur\say.cfg" "Z:\say.cfg"
mklink "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\cfg\chatur\console.log" "Z:\chatur_console.log"

type nul > Z:\say.cfg
