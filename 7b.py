#! /usr/bin/python3
import sys
from statistics import mean

f = open(sys.argv[1], "r")
crabs = [int(c) for c in f.readline().split(",")]
crabs.sort()

mean = mean(crabs)
meandiff = min(map(lambda c: abs(mean - c), crabs))
(meanc,) = (filter(lambda c: abs(mean - c == meandiff), crabs))
fuel = sum(map(lambda c: abs(meanc - c) * (1 + abs(meanc - c)) / 2, crabs))
print(int(fuel))
