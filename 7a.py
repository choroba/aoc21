#! /usr/bin/python3
import sys

f = open(sys.argv[1], "r")
crabs = [int(c) for c in f.readline().split(",")]
crabs.sort()

middle = crabs[len(crabs) // 2]
fuel = sum(map(lambda c: abs(middle - c), crabs))
print(fuel)
