#! /usr/bin/python3
import sys

heightmap = []
with open(sys.argv[1], 'r') as fh:
    for line in fh:
        heightmap.append([c for c in line[:-1]])

risk_level = 0;
for y in range(len(heightmap)):
    for x in range(len(heightmap[y])):
        current = heightmap[y][x]
        if current == 9 \
           or y > 0 and current >= heightmap[y-1][x] \
           or y < len(heightmap)-1 and current >= heightmap[y+1][x] \
           or x > 0 and current >= heightmap[y][x-1] \
           or x < len(heightmap)-1 and current >= heightmap[y][x+1]:
            continue
        risk_level += int(heightmap[y][x]) + 1
print(risk_level)
