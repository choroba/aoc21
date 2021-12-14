#! /usr/bin/python3
import sys

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

paths = [['start']]
while True:
    extendable = list(reversed(list(filter(lambda i:paths[i][-1] != 'end',
                                           range(len(paths))))))
    if not extendable:
        break

    for ie in extendable:
        e = paths.pop(ie)

        for nxt in caves[ e[-1] ]:
            new = e.copy()
            new.append(nxt)
            if nxt.lower() == nxt and nxt in e:
                continue
            paths.append(new)

print(len(paths))
