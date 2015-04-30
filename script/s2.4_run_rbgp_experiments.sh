#!/bin/bash
# author: wudanzy@csnet1.cs.tsinghua.edu.cn
# create: Jan 2014
# update: Apr 2015
#
# This this the fourth case of second step: run experiments of R-BGP
# 

. "common.sh"
check_dir $DATA_DIR
numbers=`echo "" | awk 'BEGIN{for (i=1;i<=100;i++) printf "%03d ",i}'`

for i in $numbers
do
    CONFIGFILES=$DATA_DIR"conf_rbgp"$i
    cat $DATA_DIR"conf_bgp"$i | sed -e '2 s/^.*$/config rbgp-routing/'  > $CONFIGFILES 
    $SRC_DIR"multiBgpSim.py" $CONFIGFILES > $DATA_DIR"msg_rbgp_epic"$i
done

