#! /usr/bin/python3
import sys

grid = {}
danger_tally = 0

with open(sys.argv[1], 'r') as fh:
    for line in fh:
        ((x1, y1), (x2, y2)) = map(lambda coord: map(int, coord.split(',')),
                                   line.split(' -> '))

        xstep = 1 if x1 < x2 else 0 if x1 == x2 else -1
        ystep = 1 if y1 < y2 else 0 if y1 == y2 else -1
        (x, y) = (x1, y1)

        while True:
            if not x in grid:
                grid[x] = {}
            if not y in grid[x]:
                grid[x][y] = 0
            grid[x][y] += 1
            if grid[x][y] == 2:
                danger_tally += 1
            if x == x2 and y == y2:
                break
            x += xstep
            y += ystep

print(danger_tally)
