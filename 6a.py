#!/usr/bin/python3
import sys

DAYS = 80

with open(sys.argv[1], 'r') as fh:
    init = map(int, fh.readline().split(','))
    fish = {}
    for f in init:
        if f in fish:
            fish[f] += 1
        else:
            fish[f] = 1
    for day in range(DAYS):
        nextf = {8:0}
        for d in fish:
            if d > 0:
                if d-1 in nextf:
                    nextf[d-1] += fish[d]
                else:
                    nextf[d-1] = fish[d]
            else:
                nextf[8] += fish[d]
                if 6 in nextf:
                    nextf[6] += fish[d]
                else:
                    nextf[6] = fish[d]
        fish = nextf
print(sum(fish.values()))
