#! /usr/bin/python3
import sys
sys.setrecursionlimit(15000)

heightmap = []
with open(sys.argv[1], 'r') as fh:
    for line in fh:
        heightmap.append([int(c) for c in line[:-1]])

def basin(heightmap, basin_tally, x, y, basins):
    basins[y][x] = basin_tally
    for move in ([0,1], [1,0], [0,-1], [-1,0]):
        X = x + move[0]
        Y = y + move[1]
        if (X < 0) or (Y < 0) or (Y >= len(heightmap)) or (X >= len(heightmap[Y])) or (9 == heightmap[Y][X]) or (basins[Y][X] >= 0):
            continue
        basin(heightmap, basin_tally, X, Y, basins)

basins = [[-1 for _ in range(len(heightmap[0]))] for _ in range(len(heightmap))]
basin_tally = 0;

for y in range(len(heightmap)):
    for x in range(len(heightmap[y])):
        current = heightmap[y][x]
        if current == 9 \
           or y > 0 and current >= heightmap[y-1][x] \
           or y < len(heightmap)-1 and current >= heightmap[y+1][x] \
           or x > 0 and current >= heightmap[y][x-1] \
           or x < len(heightmap[y])-1 and current >= heightmap[y][x+1]:
            continue
        basin(heightmap, basin_tally, x, y, basins)
        basin_tally += 1

size = {}
for y in range(len(heightmap)):
    for x in range(len(heightmap[y])):
        if basins[y][x] >= 0:
            if basins[y][x] in size:
                size[ basins[y][x] ] += 1
            else:
                size[ basins[y][x] ] = 1

largest3 = list(size.values())
largest3.sort()
print(largest3[-1] * largest3[-2] * largest3[-3])
