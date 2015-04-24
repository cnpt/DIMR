#!/usr/bin/awk -f
# author: wudanzy@csnet1.cs.tsinghua.edu.cn
# create: Jan 2014
# update: Apr 2015
#
# 
#

# show the statistic
# the last column is counted
BEGIN{
    maximum=0
}
{
    if ($NF in counts==0){
        counts[$NF]=1
        if ($NF > maximum) {
            maximum = $NF
        }
    } else {
        counts[$NF]++
    }
}
END{
    for (i in counts) {
        print i, counts[i]
    }
}
