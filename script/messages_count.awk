#!/usr/bin/awk -f
# author: wudanzy@csnet1.cs.tsinghua.edu.cn
# create: Jan 2014
# update: Apr 2015
#
# 
#

# for every (AS1, AS2) pairs
# counting the messages send from AS1 to AS2
BEGIN{
    SUBSEP=" "
}
{
    if (traces[$2,$4]>0)
    {
        traces[$2,$4]++
    }
    else { 
        traces[$2,$4]=1
    }
}
END{
    for (i in traces)
    {
        print i,traces[i]
    }
}
