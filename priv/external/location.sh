#!/bin/bash
set -e

[ $(id -u) = "0" ] || { sudo "$0" "$@"; exit $?; }

cd "$(dirname $0)"

pid=$(ps aux |grep [c]sgo_linux |awk -F' ' '{print $2}')
# echo "csgo pid is $pid"

PROCDIR="/proc/$pid"
MAPFILES="$PROCDIR/map_files"
CLIENT_MAP="$(grep '/client_client.so' $PROCDIR/maps |cut -d' ' -f1)"
START=0x$(echo "$CLIENT_MAP" |head -n1 |cut -d'-' -f1)
END=$(echo "$CLIENT_MAP" |tail -n1 |cut -d'-' -f2)
# echo "client.so map region is $(( 0x$END - $START )) bytes: $START-$END"
#localplayer
PATTERN="TODO"
OFFSET=0
SIZE=0
# echo "scanning for $PATTERN"
#RELADDR=$(xxd -p -g 16 -s $START -l $(( 0x$END - $START )) $PROCDIR/mem |tr -d '\n' |grep -obE "$PATTERN" |cut -d':' -f1 |head -n1 |xargs -I{} bash -c "echo {} / 2 |bc" || true)
RELADDR="0x234e748"
# printf "relative address is 0x%x\n" $RELADDR
PATTADDR=$(( $RELADDR + $START ))
# printf "absolute address is 0x%x\n" $PATTADDR
castoffset="$(xxd -p -s $(( $PATTADDR + $OFFSET )) -l 4 /proc/$pid/mem)"
localplayeraddr="$(./convert.sh $castoffset)"
# echo "readoffset: $localplayeraddr"

./read_location.sh $pid $localplayeraddr
END=${1:-0}
for ((i=1;i<END;i++)); do
	#spit location to stderr
	sleep 0.1
	./read_location.sh $pid $localplayeraddr
done
