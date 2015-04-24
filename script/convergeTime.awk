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
    time=0.0
    base_time=0.0
    messages=0
}
{
    if ($0 ~ /announce/ || $0 ~ /link/ || $0 ~ /FINISH/)
    {
        base_time=$1
        if (cnt > 0) {
            print tag, time, messages
            time=0.0
            messages=0
        }
        if ($0 ~ /announce/){
            tag="announce"
        }
        else if ($0 ~ /down/){
            tag="down"
        }
        else if ($0 ~ /up/){
            tag="up"
        }
        cnt++
    }
    else if ($0 ~ /receive/)
    {
       time=$1-base_time 
       messages++
    }
}
