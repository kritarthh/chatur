#!/usr/bin/env bash
set -euo pipefail

while IFS='$\n' read -r line; do
    # do whatever with line
    eval $line && echo ok || echo err
done
