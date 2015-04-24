#!/bin/bash
# author: wudanzy@csnet1.cs.tsinghua.edu.cn
# create: Jan 2014
# update: Apr 2015
#
# 
#

for name in `cat names`
do
    for jname in `cat names`
    do
#        echo $name, $jname
        if [ $name -ne $jname ]
        then
            cat simBGP/20120601.as-rel.pub.txt | grep ^$name\|$jname\|
        fi
    done
done
