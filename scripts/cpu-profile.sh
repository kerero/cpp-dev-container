#!/usr/bin/env bash

set -e

# TODO: There is a room for improvant and validation
if [ "$#" -ne 2 ]; then
    echo "Usage: cpu-profile <command> <output_path>"
    exit 1
fi


perf record -g -F max -o /tmp/perf.data $1 
perf script -i /tmp/perf.data > /tmp/perf.script
/opt/flame-graph/stackcollapse-perf.pl /tmp/perf.script | /opt/flame-graph/flamegraph.pl > $2/perf.svg
