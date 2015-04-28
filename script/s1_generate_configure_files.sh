#!/bin/bash
# author: wudanzy@csnet1.cs.tsinghua.edu.cn
# create: Jan 2014
# update: Apr 2015
#
# This this the first step: generating all the configure files
# 

. "common.sh"
check_dir $DATA_DIR
numbers=`echo "" | awk 'BEGIN{for (i=1;i<=100;i++) printf "%03d ",i}'`

for i in $numbers
do
#     echo $DATA_DIR$i
    $SRC_DIR"gen_topo.py" $DATA_DIR$ASTOPO_FILE > $DATA_DIR"conf_bgp"$i
done

