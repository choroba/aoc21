#! /usr/bin/python3
import sys

octopuses=[]
with open(sys.argv[1], 'r') as fh:
    for line in fh:
        octopuses.append(list(map(int, line[:-1])))

flash_tally = 0
for step in range(100):
    next = [[[] for _ in octopuses[0]] for _ in octopuses]
    flashing = []
    for y in range(len(octopuses)):
        for x in range(len(octopuses[y])):
            next[y][x] = octopuses[y][x] + 1
            if next[y][x] > 9:
                flashing.append((y, x))

    while flashing:
        (y, x) = flashing.pop(0)
        flash_tally += 1
        for dy in (-1, 0, 1):
            Y = y + dy
            if Y < 0 or Y >= len(next):
                continue

            for dx in (-1, 0, 1):
                if not(dx or dy):
                    continue

                X = x + dx
                if X < 0 or X >= len(next[Y]):
                    continue

                next[Y][X] += 1
                if 10 == next[Y][X]:
                    flashing.append((Y, X))
    for y in range(len(next)):
        for x in range(len(next[y])):
            if next[y][x] > 9:
                next[y][x] = 0
    octopuses = next
print(flash_tally)
