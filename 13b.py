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

    def show (self):
        (max_x, max_y) = (0, 0)
        for (x, y) in self.grid:
            if x > max_x: max_x = x
            if y > max_y: max_y = y
        for y in range(max_y + 1):
            for x in range(max_x + 1):
                if (x, y) in self.grid:
                    print('#', end="")
                else:
                    print('.', end="")
            print('')

paper = TransparentPaper()
fold = re.compile(r'([xy])=(\d+)')

with open(sys.argv[1], 'r') as fh:
    for line in fh:
        if line[0:4] == 'fold':
            m = fold.search(line)
            (axis, coord) = (m.group(1), int(m.group(2)))
            paper.fold(axis, coord)
        else:
            line = line.rstrip('\n')
            if line:
                paper.add(*list(map(int, line.split(','))))
paper.show()
