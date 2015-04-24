#!/usr/bin/awk -f
# author: wudanzy@csnet1.cs.tsinghua.edu.cn
# create: Jan 2014
# update: Apr 2015
#
# 
#

#classify the trace file
BEGIN{
    cnt=0
    name=tmp
    base_time=0.0
}
{
    if ($0 ~ /announce/ || $0 ~ /link/)
    {
        cnt++
        base_time=$1
        filename="tmp"cnt
    }
    else if ($0 ~ /receive/)
    {
       $1=$1-base_time 
       print $0 > filename
    }
}
END{
    for (i=1;i<=cnt;i++)
        close("tmp"cnt)
}
