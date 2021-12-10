#! /usr/bin/python3
import sys

sum = 0
with open(sys.argv[1], 'r') as fh:
    for line in fh:
        digits = list(map(
            lambda x: tuple(sorted(x)),
            line.rstrip('\n').split(' ')))

        digits.remove(('|',))
        summable = reversed([digits.pop() for _ in range(4)])
        mapping = {tuple(('a','b','c','d','e','f','g')) : 8}

        (d7,) = (d for d in digits if 3 == len(d))
        mapping[d7] = 7

        (d1,) = (d for d in digits if 2 == len(d))
        mapping[d1] = 1

        mapping['A'] = set(d7) - set(d1)

        (d4,) = (d for d in digits if 4 == len(d))
        mapping[d4] = 4

        (d9,) = (d for d in digits if 6 == len(d) and 4 == len(set(d) & set(d4)))
        mapping[d9] = 9
        mapping['E'] = set('abcdefg') - set(d9)
        mapping['G'] = set(d9) - set(d7) - set(d4)

        for d in digits:
            if 6 != len(d):
                continue

            b = set(d) & (set(d7) | mapping['E'] | mapping['G'])
            if 5 != len(b):
                continue

            mapping['B'] = set(d) - b
            mapping[d] = 0
            mapping['D'] = {'a','b','c','d','e','f','g'} - set(d)

        p = {list(mapping[s])[0] for s in 'ABEGD'}
        (d6,) = (d for d in digits if 6 == len(d) and 1 == len(set(d) - p))
        mapping[d6] = 6
        mapping['F'] = set(d1) & set(d6)
        mapping['C'] = set(d1) - mapping['F']

        for d in [d for d in digits if 5 == len(d)]:
            t = [list(set(d) & mapping[c]) for c in 'CF']
            mapping[d] = 3 if t[0] and t[1] else 2 if t[0] else 5

        n = "".join([str(mapping[s]) for s in summable])
        sum += int(n)
print(sum)
