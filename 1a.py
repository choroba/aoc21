#!/usr/bin/python3
import sys

previous = "-INF";
tally = 0
with open(sys.argv[1], 'r') as fh_in:
    for line in fh_in:
        if line > previous:
            tally += 1
        previous = line
print(tally)
