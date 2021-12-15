#! /usr/bin/python3
import sys

with open(sys.argv[1], 'r') as fh:
    template = fh.readline().rstrip('\n')

    insert = {}
    for line in fh:
        line = line.rstrip('\n')
        try:
            (From, To) = line.split(' -> ')
            insert[From] = To
        except ValueError:
            if insert:
                raise Exception('invalid input') from None

pairs = {}
for pos in range(len(template) - 1):
    pair = (template[pos:pos+1], template[pos+1:pos+2])
    if pair in pairs:
        pairs[pair] += 1
    else:
        pairs[pair] = 1

steps = 10 if sys.argv[0][-6:] == '14a.py' else 40
for step in range(1, 1 + steps):
    Next = {}
    for pair in pairs.copy():
        quantity = pairs[pair]
        del pairs[pair]
        i = insert[pair[0]+pair[1]]
        for newpair in ((pair[0], i), (i, pair[1])):
            if newpair in Next:
                Next[newpair] += quantity
            else:
                Next[newpair] = quantity
    pairs = Next

quantities = {}
for (p1, p2) in pairs:
    for p in (p1, p2):
        if p in quantities:
            quantities[p] += pairs[(p1, p2)]
        else:
            quantities[p] = pairs[(p1, p2)]
Sorted = sorted(map(lambda x: int(0.5 + x / 2), quantities.values()))
print(Sorted[-1] - Sorted[0])
