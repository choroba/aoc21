#! /usr/bin/python3
import sys
import re

class TransparentPaper:
    grid = set()

    def add (self, x, y):
        self.grid.add((x, y))

    def delete (self, x, y):
        self.grid.remove((x, y))

    def fold (self, axis, coord):
        for (x, y) in self.grid.copy():
            if axis == 'y' and y > coord:
                self.delete(x, y)
                self.add(x, 2 * coord - y)
            elif axis == 'x' and x > coord:
                self.delete(x, y)
                self.add(2 * coord -x, y)


paper = TransparentPaper()
fold = re.compile(r'([xy])=(\d+)')

with open(sys.argv[1], 'r') as fh:
    for line in fh:
        if line[0:4] == 'fold':
            m = fold.search(line)
            (axis, coord) = (m.group(1), int(m.group(2)))
            paper.fold(axis, coord)
            print(len(paper.grid))
            exit(0)
        else:
            line = line.rstrip('\n')
            if line:
                paper.add(*list(map(int, line.split(','))))
