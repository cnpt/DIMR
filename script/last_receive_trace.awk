#!/usr/bin/awk -f
# author: wudanzy@csnet1.cs.tsinghua.edu.cn
# create: Jan 2014
# update: Apr 2015
#
# 
#

# print the last message sent from the AS
{
    traces[$4]=$1
    if ($4 in counts==0)
    {
        counts[$4]=1
    } else {
        counts[$4]++
    }
}
END{
    for (i in traces)
    {
        print traces[i],counts[i]
    }
}
