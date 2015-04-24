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
  
}
#/RIB.+\*>/{
{
    checkEdges($0)
}
END {
    for (e in edges) {
        printf "[%s] %s\n", substr(e,1,length(e)-1), edges[e]
    }
}
