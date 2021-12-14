#! /usr/bin/python3
import sys
import time

DUPLICATE = 1

caves = {}
with open(sys.argv[1], 'r') as fh:
    for line in fh:
        (From, To) = line.rstrip("\n").split('-')
        if From in caves:
            caves[From].add(To)
        else:
            caves[From] = {To}
        if To in caves:
            caves[To].add(From)
        else:
            caves[To] = {From}

paths = [[['start'], False]]
while True:
    extendable = list(reversed(list(filter(lambda i:paths[i][0][-1] != 'end',
                                           range(len(paths))))))
    if not extendable:
        break

    for ie in extendable:
        e = paths.pop(ie)

        for nxt in caves[ e[0][-1] ]:
            if 'start' == nxt:
                continue

            new = e[0].copy()
            new.append(nxt)
            if nxt.upper() == nxt:
                paths.append([new, e[DUPLICATE]])
            elif e[DUPLICATE]:
                if not nxt in e[0]:
                    paths.append([new, True])
            else:
                paths.append([new, nxt in e[0]])

print(len(paths))
