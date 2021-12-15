#! /usr/bin/python3
import sys

cave = []
with open(sys.argv[1], 'r') as fh:
    for line in fh:
        cave.append([[int(c), None] for c in line.rstrip('\n')])
        smally = len(cave[-1])
        cave[-1].extend([[None, None] for _ in range(smally * 4)])
smallx = len(cave)
cave.extend([[[None, None] for _ in range(smally * 5)]
             for _ in range(smallx * 4)])

for tilex in range(5):
    for tiley in range(5):
        if not(tilex or tiley):
            continue

        for x in range(smallx):
            for y in range(smally):
                cave[tilex * smallx + x][tiley * smally + y][0] = \
                    (cave[x][y][0] + tilex + tiley) % 9 or 9

cave[0][0][1] = 0
agenda=[(0, 0)]

while agenda:
    (x, y) = agenda.pop(0)
    for move in ([0,1], [1,0], [0,-1], [-1,0]):
        X = x + move[0]
        Y = y + move[1]
        if X < 0 or X >= len(cave) or Y < 0  or Y >= len(cave[X]):
            continue

        risk = cave[x][y][1] + cave[X][Y][0]
        if not(cave[X][Y][1]) or risk < cave[X][Y][1]:
            cave[X][Y][1] = risk
            agenda.append((X, Y))

(endx, endy) = (len(cave)-1, len(cave[-1])-1)
print(cave[endx][endy][1])
