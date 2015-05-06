#!/usr/bin/env python
import os
import sys
import getopt

protocols = ['dimr', 'pdar', 'bgpxm', 'rbgp', 'yamr'];
numbers = ['%03d' %(i+1) for i in range(100)] 
BASEDIR='~/DIMR/'
DATADIR='data/'
SHELLDIR='script/'
SRCDIR='src/'

FILE_DISJOINT = 'result_disjoint'
FILE_AVERAGE = 'result_average_length'

# print numbers

def calcDisjoint():
    for index in numbers:
        disjoint_numbers = ''
        average_length = ''
        for proto in protocols:
            cmd = 'cat ' + BASEDIR + DATADIR + 'msg_' + proto + '_epic' + index + ' | ' + BASEDIR + SHELLDIR;
            cmd += 'filter.awk | ' + BASEDIR + SHELLDIR + 'parser.py';
            outcome = os.popen(cmd).readlines()
            disjoint_numbers += outcome[0][:-1] + ' ';
            average_length += outcome[1][:-1] + ' ';
        pcmd = 'echo ' + disjoint_numbers + ' >> ' + BASEDIR + DATADIR + FILE_DISJOINT
        os.system(pcmd)
        pcmd = 'echo ' + average_length + ' >> ' + BASEDIR + DATADIR + FILE_AVERAGE
        os.system(pcmd)


def main():
    calc_disjoint = False;
    try:
        options,args = getopt.getopt(sys.argv[1:],"dp",[])
    except getopt.GetoptError:
        sys.exit()

    for name,value in options:
        if name in ("-d"):
            calc_disjoint = True;
            # print "debug"
        if name in ("-p"):
            print "no implementation"
            # print "show paths"
    if calc_disjoint:
        calcDisjoint()
    # cmd='~/DIMR/src/multiBgpSim.py ~/DIMR/data/conf_yamr | ~/DIMR/script/filter.awk | ~/DIMR/script/parser.py'
    # outcome = os.popen(cmd).readlines()
    # print outcome


if __name__ == "__main__":
    main()
