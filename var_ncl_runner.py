#!/usr/bin/env python3

import sys
from itertools import product


def parse():
    args = []
    argv = sys.argv

    for counter, arg in enumerate(argv):
        if arg[:1] != '-':
            continue
        elif (counter < len(argv) - 1) and (argv[counter + 1][:1] != '-'):
            newArg = (arg, argv[counter + 1].split(" "))
        else:
            newArg = (arg, '')
        args.append(newArg)
        if counter + 1 == len(argv):
            scr = argv[counter]

    return args


def runner(args):
    keys, value_list = zip(*args)
    for item in product(*value_list):
        v_list = ['{}={}'.format(key[1:], val) for key, val in zip(keys, item)]
        print('prefix {} suffix'.format(' '.join(v_list)))


if __name__ == '__main__':
    runner(parse())
