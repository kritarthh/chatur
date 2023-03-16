#!/bin/bash
set -e

[ $(id -u) = "0" ] || { sudo "$0" "$@"; exit $?; }

function hextofloat() {
	echo -n "$1" |fold -w2 |tr '\n' ' ' |sed "s/^/\\\x/" |sed "s/ /\\\x/g" |xargs --null echo -ne |hexdump -e '1/4 "%f" "\n"' |tr '\n' ' '
} ; export -f hextofloat ;

printf "setpos "
#xyz
xxd -p -s $(( $2 + 0xd8 )) -l 12 /proc/$1/mem \
	|parallel -P1 hextofloat {} ;

#abg
xxd -p -s $(( $2 + 0x164 )) -l 12 /proc/$1/mem \
	|parallel -P1 hextofloat {} |xargs --null printf ";setang %s\n" ;
