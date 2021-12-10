#! /usr/bin/python3
import sys

count = 0
with open(sys.argv[1], 'r') as fh:
    for line in fh:
        pos = line.index('|')
        count += len(list(filter(lambda l:l in (2,3,4,7),
                                 map(len,
                                     line[2+pos:].rstrip('\n').split(' ')))))
print(count)
