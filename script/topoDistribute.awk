#!/usr/bin/awk -f
# author: wudanzy@csnet1.cs.tsinghua.edu.cn
# create: Jan 2014
# update: Apr 2015
#
# 
#

BEGIN{
    FS="[|]"
}

/^[0-9][0-9]*\|/{
    counter[$1]++
    counter[$2]++
    if (provider[$1]=="")
        provider[$1]=0
    if (peer[$1]=="")
        peer[$1]=0
    if (client[$1]=="")
        client[$1]=0
    if (provider[$2]=="")
        provider[$2]=0
    if (peer[$2]=="")
        peer[$2]=0
    if (client[$2]=="")
        client[$2]=0
    if ($3==-1) 
    {
        provider[$2]++
        client[$1]++
    }
    else if ($3==0||$3==2)
    {
        peer[$1]++
        peer[$2]++
    }
}
END{
    for (i in counter)
        print i, counter[i], provider[i], client[i], peer[i]
}
