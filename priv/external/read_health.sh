#!/bin/bash
set -e

pid=$1
playerresaddr=$2

idx=-1
data=""
for i in $(seq 0 16); do
	idx=$((idx+1))
	#team
	name="$(xxd -p -s $(( $playerresaddr + 0x15d1 + $idx * 4 )) -l 4 /proc/$pid/mem)"
	name=$(echo $((16#$name)))
	#2-T,3-CT
	team="T"
	if [ "$name" = "3" ]; then
		team="CT"
	fi
	#team=$(echo $((16#$name)))
	name="$(xxd -p -s $(( $playerresaddr + 0xf78 + $i * 8 )) -l 8 /proc/$pid/mem)"
	pr="$(./convert.sh $name)"
	name="$(xxd -p -s $(( $pr )) -l 64 /proc/$pid/mem |tr -d '\n' |awk -F '00' '{print $1}' |fold -w2 |xxd -p -r)"
	if [ "$name" = "unconnected" ] || [ "$name" = "GOTV" ] ; then
		continue
	fi
	data="$data$team"
	data="$data: $name"
	#health
	health="$(xxd -p -s $(( $playerresaddr + 0x171d + 0x100 + $idx * 4 )) -l 4 /proc/$pid/mem)"
	health=$(echo -n $((16#$health)))
	if [ "$health" = "0" ] ; then
		continue
	fi
	data="$data: $health\n"
	#wins and rank
	#name="$(xxd -p -s $(( $playerresaddr + 0x171d + 0x1b88 + $idx * 4 )) -l 4 /proc/$pid/mem)"
	#data="$data: $name\t\t\t<br/>\n"
	#		echo $name
done
datas="$(echo -e "$data" |sort -h)"
echo -e "$datas"
#datas="<html><head><meta http-equiv=\"refresh\" content=\"1\"></head><body>$datas</body></html>"
#echo -e "$datas" > /tmp/health/data.txt
