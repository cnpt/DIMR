#!/bin/bash
# author: wudanzy@csnet1.cs.tsinghua.edu.cn
# create: Jan 2014
# update: Apr 2015
#
# Calculate all the metrics automatically
#

# Common settings
. "common.sh"
# All the directories to be calculated
list=`ls $DATA_DIR | grep ^[A-Z][a-z][a-z]`
for i in $list
do
    dirname=$DATA_DIR$i"/"
    # Figure out the names of corresponding files
    convergename=$DATA_DIR"convergetime_"$i
    disfilename=$DATA_DIR"pathdistribute_"$i
    pathfilename=$DATA_DIR"disjointpath_"$i
    strefilename=$DATA_DIR"pathstreches_"$i
    # Then, excute all the commands 
    $SHELL_DIR/counting.sh $dirname > $convergename
    $SHELL_DIR/pathDistribute.sh $dirname > $disfilename
    $SHELL_DIR/disjointPath.sh $dirname > $pathfilename
    $SHELL_DIR/streches.sh $dirname > $strefilename
done
