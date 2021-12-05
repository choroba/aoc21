#! /usr/bin/python3
import sys

grid = {}
danger_tally = 0

def inc(arr, x, y):
    if not x in arr:
        arr[x] = {}
    if not y in arr[x]:
        grid[x][y] = 0
    grid[x][y] += 1
    return 1 if grid[x][y] == 2 else 0
    
with open(sys.argv[1], 'r') as fh:
    for line in fh:
        ((x1, y1), (x2, y2)) = map(lambda coord: map(int, coord.split(',')),
                                   line.split(' -> '))
        if x1 != x2 and y1 != y2:
            continue
        if x1 == x2 :
            if y2 < y1:
                 (y1, y2) = (y2, y1)
            for y in range(y1, y2 + 1):
                danger_tally += inc(grid, x1, y)
        elif y1 == y2:
            if x2 < x1:
                (x1, x2) = (x2, x1)
            for x in range(x1, x2 + 1):
                danger_tally += inc(grid, x, y1)

print(danger_tally)
