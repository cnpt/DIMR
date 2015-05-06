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
FILE_CONVERGE = 'result_converge'
FILE_UPDATE = 'result_update'

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

def calcEvents():
    for index in numbers:
        converge_time = None;
        updates = None;
        for proto in protocols:
            cmd = BASEDIR + SHELLDIR + 'convergeTime.awk ' + BASEDIR + DATADIR + 'msg_' + proto + '_epic' + index;
            # print cmd
            outcome = os.popen(cmd).readlines()
            if converge_time is None:
                converge_time = [[None, ' '] for i in range(len(outcome))];
                updates = [[None, ' '] for i in range(len(outcome))];
            for i in range(len(outcome)):
                data = outcome[i][:-1].split(' ');
                converge_time[i][0] = data[0];
                converge_time[i][1] += data[1] + ' ';
                updates[i][0] = data[0];
                updates[i][1] += data[2] + ' ';
            # print converge_time;
            # print updates;
        for line in converge_time:
            pcmd = 'echo ' + line[1] + ' >> ' + BASEDIR + DATADIR + FILE_CONVERGE + '_' + line[0];
            # print pcmd;
            os.system(pcmd)
        for line in updates:
            pcmd = 'echo ' + line[1] + ' >> ' + BASEDIR + DATADIR + FILE_UPDATE + '_' + line[0];
            # print pcmd;
            os.system(pcmd)


def main():
    calc_disjoint = False;
    calc_converge = False;
    try:
        options,args = getopt.getopt(sys.argv[1:],"dc",[])
    except getopt.GetoptError:
        sys.exit()

    for name,value in options:
        if name in ("-d"):
            calc_disjoint = True;
            # print "debug"
        if name in ("-c"):
            calc_converge = True;
            # print "show paths"
    if calc_disjoint:
        calcDisjoint();
    if calc_converge:
        calcEvents();


if __name__ == "__main__":
    main()
