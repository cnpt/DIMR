#!/usr/bin/awk -f
# author: wudanzy@csnet1.cs.tsinghua.edu.cn
# create: Jan 2014
# update: Apr 2015
#
# 
#

#classify the trace file
BEGIN{
    yes=0
    no=0
    single=0
}
{
    if ($0 ~ /Y/)
    {
        yes++
    }
    else if ($0 ~ /N/)
    {
       no++
    }
    else if ($0 ~ /-/)
    {
        single++
    }
}
END{
    print yes
    print no
    print single
}
