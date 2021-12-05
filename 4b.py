#! /usr/bin/python3
import sys

numbers = []
boards  = []
where   = {}

def mark (n):
    global boards, where
    won = -1
    for w in where[n]:
        (board, y, x) = w
        boards[board]['nums'] -= {n}
        boards[board]['cols'][x] -= 1
        if 0 == boards[board]['cols'][x]:
            boards[board]['won'] = True
            won = board
        boards[board]['rows'][y] -= 1
        if 0 == boards[board]['rows'][y]:
            boards[board]['won'] = True
            won = board
        if len([b for b in boards if b['won']]) == len(boards):
            return won
    return -1

def score (n, board):
    global boards
    return sum(map(int, boards[board]['nums'])) * n

with open(sys.argv[1], 'r') as fh:
    numbers = list(map(int, fh.readline().split(',')))

    for line in fh:
        if ("\n" == line):
            boards.append({'nums': set(),
                           'cols': {},
                           'rows': {},
                           'won': False})
        else:
            ns = list(map(int, filter(len, line.strip().split(' '))));
            for x in range(len(ns)):
                board = len(boards) - 1
                y     = int(len(boards[-1]['nums']) / (len(ns)))
                n     = ns[x]

                if n in where:
                    where[n] |= {(board, y, x)}
                else:
                    where[n] = {(board, y, x)}

                if x in boards[board]['cols']:
                    boards[board]['cols'][x] += 1
                else:
                    boards[board]['cols'][x] = 1

                if y in boards[board]['rows']:
                    boards[board]['rows'][y] += 1
                else:
                    boards[board]['rows'][y] = 1
                boards[board]['nums'] |= {n}

for n in numbers:
    board = mark(n)
    if board >= 0:
        print(score(n, board))
        break
