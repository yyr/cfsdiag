#!/usr/bin/env python3
"""
Usage:
nclrunner.py -a '1 2' -b '1 2 3' myscript.ncl

This will iterate and run as follows.

ncl 'a="1"' 'b="1"'  myscript.ncl
ncl 'a="1"' 'b="2"'  myscript.ncl
ncl 'a="1"' 'b="3"'  myscript.ncl
ncl 'a="2"' 'b="1"'  myscript.ncl
ncl 'a="2"' 'b="2"'  myscript.ncl
ncl 'a="2"' 'b="3"'  myscript.ncl
"""

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

    return args, argv[-1]


def runner(opts, scr):
    keys, value_list = zip(*opts)
    for item in product(*value_list):
        # FIXME: ncl may get choked if numbers are passed as strings
        v_list = ['\'{}="{}"\''.format(key[1:], val)
                  for key, val in zip(keys, item)]
        print('ncl {} '.format(' '.join(v_list)), scr)


if __name__ == '__main__':
    args, scr = parse()
    runner(args, scr)
