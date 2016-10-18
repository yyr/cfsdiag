#!/usr/bin/env python3

import sys
from itertools import product


def parse():
    args = []
    argv = sys.argv

    for counter, arg in enumerate(argv):
        if (counter == len(argv) - 1):
            scr = argv[counter]
        elif arg[:1] != '-':
            continue
        elif (counter < len(argv) - 1) and (argv[counter + 1][:1] != '-'):
            newArg = (arg, argv[counter + 1].split(" "))
        else:
            newArg = (arg, '')
        args.append(newArg)

    return args, scr


def runner(opts, scr):
    keys, value_list = zip(*opts)
    for item in product(*value_list):
        v_list = ['\'{}="{}"\''.format(key[1:], val)
                  for key, val in zip(keys, item)]
        print('ncl {} '.format(' '.join(v_list)), scr)


if __name__ == '__main__':
    args, scr = parse()
    runner(args, scr)
