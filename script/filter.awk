#!/usr/bin/awk -f
# author: wudanzy@csnet1.cs.tsinghua.edu.cn
# create: Jan 2014
# update: Apr 2015
#
# Filter the RIB data and get the AS PATH
# format: IP Address(AS number) Y/N/- Length1 Length2 [AS PATH1] [AS PATH2]
# 4.2.4.92(42492) Y 4 4 [24785, 286, 9050, 43899] [25525, 6453, 31313, 43899]
#

function disjoint(p1, p2)
{
    ret=0
    for (i=1;i<length(p1);i++)
        map[p1[i]]=true
    for (i=1;i<length(p2);i++)
        if (p2[i] in map)
            ret++
    for (i in map)
        delete map[i]
    return ret
}
function checkPaths(str)
{
    regex="\\[[0-9, ]+\\]"
    match(str, regex)
    i=0
    while (RSTART)
    {
        paths[i]=substr(str,RSTART,RLENGTH)
        i++
        str=substr(str,RSTART+RLENGTH)
        match(str, regex)
    }
    if (length(paths) >= 2)
    {
        len1=split(substr(paths[0],2,length(paths[0])-2),p1,", ")
        len2=split(substr(paths[1],2,length(paths[1])-2),p2,", ")
        if (disjoint(p1,p2)==0)
            printf "Y "
        else 
            printf "N "
        print len1,len2,paths[0],paths[1]
    }
    else if (length(paths)==1)
    {
        len=split(substr(paths[0],2,length(paths[0])-2),p1,", ")
        print "-", len, paths[0]
    }
    else if (length(paths)==0)
    {
        print "- 0"
    }
    for (i in paths)
        delete paths[i]
}

BEGIN {
    FS="[{}]"
}
#/RIB.+\*>/{
/RIB/{
    as_regex="([0-9]+\\.)+[0-9]+\\([0-9]+\\)"
    match($1,as_regex)
    as=substr($1,RSTART,RLENGTH)
    printf "%s ", as
    checkPaths($2)
}
