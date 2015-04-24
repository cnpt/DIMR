#!/usr/bin/awk -f
# author: wudanzy@csnet1.cs.tsinghua.edu.cn
# create: Jan 2014
# update: Apr 2015
#
# 
#

function count(edge)
{
    if (edge in edges==0){
        edges[edge]=1
    } else {
        edges[edge]++
    }
}
function checkEdges(str)
{
    regex="[0-9]+,\\ [0-9]+\\]"
    match(str, regex)
    i=0
    while (RSTART)
    {
        edge=substr(str,RSTART,RLENGTH)
        count(edge)
        str=substr(str,RSTART+RLENGTH)
        match(str, regex)
    }
}

BEGIN {
    short = 0
    long = 0
    shorty = 0
    longy = 0
    y = 0
    cnt=0
}
#/RIB.+\*>/{
{
    if ($3 ~ /[0-9]*/ && $4 ~ /[0-9]*/)
    {
        short = short + $3
        long = long + $4
        cnt++
        if ($2 ~ /Y/){
            shorty = shorty + $3
            longy = longy + $4
            y++
        }
    }
}
END {
    if (cnt > 0) {
        print "short",(short*1.0)/cnt, cnt
        print "long",(long*1.0)/cnt, cnt
        print "average",(short+long)*0.5/cnt, cnt
    }
    if (y > 0) {
        print "disjoint short", (shorty*1.0)/y, y
        print "disjoint long", (longy*1.0)/y, y
        print "disjoint average", (shorty+longy)*0.5/y, y
    }
}
