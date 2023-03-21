#!/bin/bash
set -e

cd "$(dirname $0)"

echoerr() { echo "$@" 1>&2; }
if [ "$1" != "" ] ; then
	echoerr() { echo "$@" >/dev/null; }
fi

pid=$(ps aux |grep [c]sgo_linux |awk -F' ' '{print $2}')
echoerr "csgo pid is $pid"

PROCDIR="/proc/$pid"
MAPFILES="$PROCDIR/map_files"
CLIENT_MAP="$(grep '/client_client.so' $PROCDIR/maps |cut -d' ' -f1)"
START=0x$(echo "$CLIENT_MAP" |head -n1 |cut -d'-' -f1)
END=$(echo "$CLIENT_MAP" |tail -n1 |cut -d'-' -f2)
echoerr "client.so map region is $(( 0x$END - $START )) bytes: $START-$END"
PATTERN=${1:-488d[0-9a-z]{10}488d[0-9a-z]{10}e8[a-z0-9]{8}5d488d[a-z0-9]{10}488d[0-9a-z]{10}488d[a-z0-9]{10}e9[0-9a-z]{16}55488d}
#entity
PATTERN="488d[0-9a-z]{10}488d[0-9a-z]{10}e8[a-z0-9]{8}5d488d[a-z0-9]{10}488d[0-9a-z]{10}488d[a-z0-9]{10}e9[0-9a-z]{16}55488d"
#resource
PATTERN="488b05[0-9a-z]{8}554889e54885c0741048"
OFFSET=3
SIZE=7
echoerr "scanning for $PATTERN"
#RELADDR=$(xxd -p -g 16 -s $START -l $(( 0x$END - $START )) $PROCDIR/mem |tr -d '\n' |grep -obE "$PATTERN" |cut -d':' -f1 |head -n1 |xargs -I{} bash -c "echo {} / 2 |bc" || true)
RELADDR="0x84d590"
echoerr "relative address is 0x%x\n" $RELADDR
PATTADDR=$(( $RELADDR + $START ))
echoerr "absolute address is 0x%x\n" $PATTADDR
castoffset="$(xxd -p -s $(( $PATTADDR + $OFFSET )) -l 4 /proc/$pid/mem)"
readoffset="$(./convert.sh $castoffset)"
echoerr "readoffset: $readoffset"

absoluteaddr="$(xxd -p -s $(( $PATTADDR + $readoffset + $SIZE )) -l 4 /proc/$pid/mem)"
playerresaddr="$(./convert.sh $absoluteaddr)"
echoerr "absolute addr: $playerresaddr"

./read_health.sh $pid $playerresaddr
END=${1:-0}
for ((i=1;i<END;i++)); do
	sleep 0.1
	./read_health.sh $pid $playerresaddr
done
