#!/bin/bash
# author: wudanzy@csnet1.cs.tsinghua.edu.cn
# create: Jan 2014
# update: Apr 2015
#
# 
#

flag=0
while [ $flag -eq 0 ]
do
    numbers=`ps aux | grep auto | awk '{print $2}'`
    flag=1
    for i in $numbers
    do
        echo $i
        if [ $i == 9584 ]
        then
            flag=0
            break
            echo "yes"
        fi
    done 
    sleep 10s
done  
