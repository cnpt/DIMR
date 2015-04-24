#!/bin/bash
# author: wudanzy@csnet1.cs.tsinghua.edu.cn
# create: Jan 2014
# update: Apr 2015
#
# This this the first case of second step: run experiments of DIMR
# 

. "common.sh"
check_dir $DATA_DIR
numbers=`echo "" | awk 'BEGIN{for (i=1;i<=100;i++) printf "%03d ",i}'`

for i in $numbers
do
    cat $DATA_DIR"conf_bgp"$i | sed '1 s/!//' > $DATA_DIR"conf_dimr"$i
    $SRC_DIR"multiBgpSim.py" $DATA_DIR"conf_dimr"$i > $DATA_DIR"msg_dimr_epic"$i
done

