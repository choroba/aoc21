#! /usr/bin/python3
import sys

depth = 0
horiz = 0

def forward(amount):
    global horiz
    horiz += amount

def up(amount):
    global depth
    depth -= amount

def down(amount):
    global depth
    depth += amount

with open(sys.argv[1], 'r') as fh:
    for line in fh:
        (direction, amount) = line.split()
        {
            'forward': forward,
            'up'     : up,
            'down'   : down
        }[direction](int(amount))
print(depth * horiz)
