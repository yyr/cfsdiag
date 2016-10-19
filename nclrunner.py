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


def prepare_command(opts, scr):
    keys, value_list = zip(*opts)
    cmds = []
    for item in product(*value_list):
        # FIXME: ncl may get choked if numbers are passed as strings
        v_list = ['\'{}="{}"\''.format(key[1:], val)
                  for key, val in zip(keys, item)]
        cmds.append('ncl {} {scr}'.format(' '.join(v_list), scr=scr))

    return cmds


def run_command(coms):
    print("\n running: {}".format(com))
    import subprocess
    subprocess.call(com, shell=True)


if __name__ == '__main__':
    args, scr = parse()
    coms = prepare_command(args, scr)
    for com in coms:
        run_command(com)
