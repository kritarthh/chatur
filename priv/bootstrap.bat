copy startup.cfg "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\cfg\chatur\startup.cfg"

mkdir "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\cfg\chatur\"
mklink "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\cfg\chatur\say.cfg" "C:\say.cfg"
mklink "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\cfg\chatur\console.log" "C:\console.log"

type nul > C:\say.cfg
type nul > C:\console.cfg
