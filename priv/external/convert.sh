#!/bin/bash

args="$@"
addr="0x$(echo "$args" |tr -d ' ' |fold -w2 |tac |tr -d '\n')"
echo $addr
