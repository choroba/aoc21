#! /usr/bin/python3
import sys

bit_frequency = []
with open(sys.argv[1], 'r') as fh:
    for line in fh:
        for i in range(0, len(line) - 1):
            if len(bit_frequency) <= i:
                bit_frequency.append([0, 0])
            bit_frequency[i][int(line[i])] += 1

gamma = "".join(map(lambda x: "0" if x[0] > x[1] else "1", bit_frequency))
epsilon = gamma.translate(gamma.maketrans("01", "10"))
print(int(gamma, 2) * int(epsilon, 2))
