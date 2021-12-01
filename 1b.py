#!/usr/bin/python3
import sys

tally = 0
with open(sys.argv[1], 'r') as fh_in:
    window = [int(fh_in.readline()) for _ in range(1, 4)]
    sumw = sum(window)
    for line in map(int, fh_in):
        newsum = line + sumw - window.pop(0)
        if newsum > sumw:
            tally += 1
        sumw = newsum
        window.append(line)
print(tally)
