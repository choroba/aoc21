#! /usr/bin/python3
import sys

TYPE = {4: 'LITERAL',
        0: 'SUM',
        1: 'PRODUCT',
        2: 'MINIMUM',
        3: 'MAXIMUM',
        5: 'GT',
        6: 'LT',
        7: 'EQ'}

def product(ar):
    p = 1
    for n in ar:
        p *= n
    return p

def gt(ar):
    return 1 if ar[0] > ar[1] else 0
def lt(ar):
    return 1 if ar[0] < ar[1] else 0
def eq(ar):
    return 1 if ar[0] == ar[1] else 0

DISPATCH = {
    'SUM'     : sum,
    'PRODUCT' : product,
    'MINIMUM' : min,
    'MAXIMUM' : max,
    'GT'      : gt,
    'LT'      : lt,
    'EQ'      : eq}

def parse (binary):
    packet = {'sum':0}
    packet['version'] = int(binary[0:3], 2)
    packet['type'] = TYPE[int(binary[3:6], 2)]
    binary = binary[6:]

    if 'LITERAL' == packet['type']:
        groups = []
        while True:
            groups.append(binary[0:5])
            binary = binary[5:]
            if groups[-1][0] == '0':
                break
        packet['value'] = int("".join(map(lambda s: s[1:], groups)), 2)
    else:
        if binary[0:1] == '1': # Number of subpackets
            count = int(binary[1:12], 2)
            binary = binary[12:]
            for _ in range(count):
                (p, rest) = parse(binary)
                if not 'packets' in packet:
                    packet['packets'] = []
                packet['packets'].append(p)
                packet['sum'] += p['version'] + p['sum']
                binary = rest

        else: # Length of subpackets
            length = int(binary[1:16], 2)
            binary = binary[16:]
            while length:
                (p, rest) = parse(binary)
                length -= len(binary) - len(rest)
                if not 'packets' in packet:
                    packet['packets'] = []
                packet['packets'].append(p)
                packet['sum'] += p['version'] + p['sum']
                binary = rest
        packet['value'] = DISPATCH[ packet['type'] ](
            list(map(lambda p: p['value'], packet['packets'])))

    return packet, binary

with open(sys.argv[1], 'r') as fh:
    line = fh.readline().rstrip('\n')
    binary = bin(int(line, 16))[2:]
    binary = binary.zfill(4 * len(line))
    (p, rest) = parse(binary)
    if '1' in rest:
        raise ValueError('Unparsable ' + rest)
    print(p['value'])
