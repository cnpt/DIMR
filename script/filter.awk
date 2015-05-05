#!/usr/bin/awk -f
# author: wudanzy@csnet1.cs.tsinghua.edu.cn
# create: Jan 2014
# update: Apr 2015
#
# Filter the RIB data and get the AS PATH
# format: AS number [AS PATH1] [AS PATH2]
# 42492 [24785, 286, 9050, 43899] [25525, 6453, 31313, 43899]
#

function checkPaths(str)
{
    regex="\\[[0-9,()set\\[\\] ]+\\]"
    match(str, regex)
    i=0
    while (RSTART)
    {
        paths[i]=substr(str,RSTART,RLENGTH)
        str=substr(str,RSTART+RLENGTH)
        match(str, regex)
        printf "|%s",paths[i]
        i++
    }
    print ""
}

BEGIN {
    FS="[{}]"
    OFS="|"
}
#/RIB.+\*>/{
/RIB/{
    # as_regex="([0-9]+\\.)+[0-9]+\\([0-9]+\\)"
    as_regex="\\([0-9]+\\)"
    match($1,as_regex)
    as=substr($1,RSTART+1,RLENGTH-2)
    printf "%s", as
    checkPaths($2)
}
