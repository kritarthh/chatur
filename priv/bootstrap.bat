SET mypath=%~dp0

copy %mypath%startup.cfg "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\cfg\chatur.cfg"
copy %mypath%nadeking.cfg "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\cfg\nadeking.cfg"

mkdir "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\cfg\chatur\"
mklink "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\cfg\chatur\say.cfg" "R:\say.cfg"
mklink "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\cfg\chatur\console.log" "R:\console.log"

type nul > R:\say.cfg
type nul > R:\console.log
