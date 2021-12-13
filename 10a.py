#! /usr/bin/python3
import sys

class SyntaxChecker:
    stack = []

    scores = {')': 3, ']': 57, '}': 1197, '>': 25137}
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
                return self.scores[ch]
        return 0

score = 0
sc = SyntaxChecker()

with open(sys.argv[1], 'r') as fh:
    for line in fh:
        line = line[:-1]
        score += sc.score(line)
print(score)
