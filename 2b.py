#! /usr/bin/python3
import sys

aim   = 0
depth = 0
horiz = 0

def forward(amount):
    global horiz, depth, aim
    horiz += amount
    depth += amount * aim

def up(amount):
    global aim
    aim -= amount

def down(amount):
    global aim
    aim += amount

with open(sys.argv[1], 'r') as fh:
    for line in fh:
        (direction, amount) = line.split()
        {
            'forward': forward,
            'up'     : up,
            'down'   : down
        }[direction](int(amount))
print(depth * horiz)
