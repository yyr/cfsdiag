#!/usr/bin/env python3

import sys


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
    return args


def ncl_runner(args):
    for item in args:
        op, val = item
        for v in val:
            # ncl_runner
            print("running " + op[1:] + "=" + v)


if __name__ == '__main__':
    ncl_runner(parse())
