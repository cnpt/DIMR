#!/bin/bash
# this program automatically do the following things
# 1 generate the topology and announce prefix randomly, select one of the link to down and up
# 2 run bgp pdar and mdr on this topology
ROOT_DIR=".."
DATA_DIR=$ROOT_DIR/data
SRC_DIR=$ROOT_DIR/src
TIME=`date +%b%d%H%M`
WORKING_DIR=$DATA_DIR/$TIME
if [ ! -d $WORKING_DIR ]
then
    mkdir $WORKING_DIR
fi
for i in {1..10}
do
    $SRC_DIR/gen_topo.py $DATA_DIR/20120601.as-rel.pub.txt > $WORKING_DIR/bgp_conf
    $SRC_DIR/multiBgpSim.py $WORKING_DIR/bgp_conf > $WORKING_DIR/msg_bgp_epic$i
    cat $WORKING_DIR/bgp_conf | sed '2 s/!//' > $WORKING_DIR/pdar_conf
    $SRC_DIR/multiBgpSim.py $WORKING_DIR/pdar_conf > $WORKING_DIR/msg_pdar_epic$i
    cat $WORKING_DIR/bgp_conf | sed '1 s/!//' > $WORKING_DIR/mdr_conf
    $SRC_DIR/multiBgpSim.py $WORKING_DIR/mdr_conf > $WORKING_DIR/msg_mdr_epic$i
done

