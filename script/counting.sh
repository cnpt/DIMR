#!/bin/bash
# author: wudanzy@csnet1.cs.tsinghua.edu.cn
# create: Jan 2014
# update: Apr 2015
#
# Calculate the converge time by analyzing the trace files
#

BGP="msg_bgp_epic"
PDAR="msg_pdar_epic"
MDR="msg_mdr_epic"
SUFFIX="tmp_converge_time_"
usage() {
    echo "counting.sh dir"
    exit 1
}
if [ $# -ne 1 ]
then
    usage
fi
PDIR=$1
log_debug "souce file from "$PDIR
if [ ! -d $PDIR ]
then
    usage
fi
for i in {1..100}
do
    bgpfile=$PDIR$BGP$i
    pdarfile=$PDIR$PDAR$i
    mdrfile=$PDIR$MDR$i
    bgpout=$SUFFIX$BGP
    pdarout=$SUFFIX$PDAR
    mdrout=$SUFFIX$MDR
    if [ -f $bgpfile ] && [ -f $pdarfile ] && [ -f $mdrfile ]
    then
        echo ""
        echo "-----"$i"-----"
        ./convergeTime.awk $bgpfile > $bgpout
        ./convergeTime.awk $pdarfile > $pdarout
        ./convergeTime.awk $mdrfile > $mdrout
        paste $bgpout $pdarout $mdrout
    else
        rm $bgpout $pdarout $mdrout
        break
    fi
done
