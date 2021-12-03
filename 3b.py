#! /usr/bin/python3
import sys

def process (binaries, gt):
    pos = 0
    while len(binaries) > 1:
        count1 = sum([b[pos:pos+1] == "1" for b in binaries])
        l2 = len(binaries) / 2

        compare = count1 >= l2 if gt else count1 <= l2
        compare = "1" if compare else "0"

        binaries = list(filter(lambda b: compare == b[pos:pos+1], binaries))
        pos += 1
    return binaries[0]

with open(sys.argv[1], 'r') as fh:
    oxygens = [line[0:-1] for line in fh]

neg  = str.maketrans("01", "10")
co2s = [o.translate(neg) for o in oxygens]

oxygen = process(oxygens, 1)
co2    = process(co2s,    0).translate(neg)
print(int(oxygen, 2) * int(co2, 2))
