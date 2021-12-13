#! /usr/bin/python3
import sys

class SyntaxChecker:
    stack = []

    scores = {')': 1, ']': 2, '}': 3, '>': 4}
    expect = {'(':')', '[':']', '{':'}', '<':'>'}

    def clean_stack (self):
        self.stack = []

    def push_stack (self, ch):
        self.stack.append(ch)

    def pop_stack (self):
        return self.stack.pop()

    def score (self, line):
        self.clean_stack()
        for ch in line:
            if ch in self.expect:
                self.push_stack(self.expect[ch])
            elif ch != self.pop_stack():
                return 0
        s = 0
        while len(self.stack):
            ch = self.pop_stack()
            s *= 5
            s += self.scores[ch]
        return s

scores = []
sc = SyntaxChecker()

with open(sys.argv[1], 'r') as fh:
    for line in fh:
        line = line[:-1]
        score = sc.score(line)
        if score:
            scores.append(score)
scores.sort()
print(scores[int(len(scores)/2)])
