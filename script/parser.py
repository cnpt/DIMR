#!/usr/bin/env python
import re
import sys

ases = {} # a dictionary of ASes, AS number as the key

class AS:
    number = None;
    visited = None;
    paths = None;
    bottelneck = None;
    hasDisjoint = None;
    disjointPaths = None;

    def __init__(self, num):
        # print "AS created",num
        self.number = num;
        self.visited = False;
        self.paths = [];
        self.bottelneck = set([]);
        #self.hasDisjoint = False;
        
    def __str__(self):
        tmp = str(self.number) + " " + str(self.hasDisjoint) + " " + str(self.disjointPaths);
        # tmp = str(self.number) + str(self.paths) + str(self.bottelneck) + str(self.hasDisjoint);
        return tmp

    def findDisjoint(self):
        if self.hasDisjoint == False:
            return
        # if it contains only one path or no path
        if len(self.paths) < 2:
            self.hasDisjoint = False;
            return;
        
        # the algorithm
        allPaths = []; # all paths, each path is presented by a set
        allowedPathIdSets = {}; # key is the asn, value is the set of PathIds of who don't contain that asn
        for path in self.paths:
            allPaths.append(set(path[:-1]));
        # fullPathIdSet = set(range(len(pathList)));
        # initialize the allowedPathIdSets
        for pathId in range(len(allPaths)):
            for asn in allPaths[pathId]:
                if not allowedPathIdSets.has_key(asn):
                    allowedPathIdSets[asn] = set(range(len(allPaths)));
                allowedPathIdSets[asn].remove(pathId);
        # print self.number
        # print "pathsets:", allowedPathIdSets;
        # print "pathList:", allPaths;
        #         
        # find one pathSet who contains the smallest number
        # since there are more than one path exist, the minIndex can always become valid
        minLength = len(allPaths)+1;
        selectedASN = None;
        for asn in allowedPathIdSets:
            if minLength > len(allowedPathIdSets[asn]):
                minLength = len(allowedPathIdSets[asn]);
                selectedASN = asn;
        # print "selected", selectedASN, allowedPathIdSets[selectedASN]
        
        # for each PathId in the set
        while len(allowedPathIdSets[selectedASN]) > 0:
            # althought that pathSets[minIndex] is changed, 
            # pathList[i] will never contains minIndex
            # i in pathSets[minIndex] means that path i doesn't contain minIndex
            # j can never be minIndex
            # so, it is ok to use pop()
            pid = allowedPathIdSets[selectedASN].pop() 
            # print "checking", pid;
            results = set(range(len(allPaths)));
            for asn in allPaths[pid]:
                # print "adding", asn
                results &= allowedPathIdSets[asn];
            # print "tmpSet is ", results
            if len(results) > 0:
                for k in results:
                    # print self.number, "disjoint path", self.paths[pid], self.paths[k];
                    self.hasDisjoint = True;
                    self.disjointPaths = [self.paths[pid], self.paths[k]];
                    return True;
            else:
                for asn in allowedPathIdSets:
                    # print pathSets[key];
                    allowedPathIdSets[asn].discard(pid)
        # print "no disjoint path"
        self.hasDisjoint = False;
        return False;
        
    def visit(self):
        if self.visited:
            return;
        i = 0;
        while i < len(self.paths):
            path = self.paths[i];
            if len(path) > 1 and isinstance(path[-1],set):
                ases[path[0]].visit();
                self.paths.pop(i);
                for tmp in ases[path[0]].paths:
                    npath = [path[0]];
                    npath.extend(tmp);
                    self.paths.append(npath);
            else:
                if i == 0:
                    self.bottelneck = set(path);
                    self.bottelneck.remove(path[-1])
                else:
                    tmp = set(path);
                    # self.bottelneck = self.bottelneck & tmp;
                    self.bottelneck &= tmp;
                i = i + 1;
        if len(self.bottelneck) or len(self.paths) < 2:
            self.hasDisjoint = False;
        self.findDisjoint();
        self.visited = True




# filename='filtered_ribs'
filename='ribs'
ribs=None;

if len(sys.argv) > 1:
    filename = sys.argv[1];
    ribs=open(filename).read().split('\n')
else:
    ribs=sys.stdin.read().split('\n')

if len(ribs[-1])==0:
    ribs.pop(-1);
for line in ribs:
    tokens = line.split('|');
    name = eval(tokens[0]);
    ases[name] = AS(name);
    i = 1;
    while i < len(tokens):
        ases[name].paths.append(eval(tokens[i]));
        i = i + 1;

for key in ases:
    ases[key].visit();
    
cnt = 0;
for key in ases:
    if ases[key].hasDisjoint:
        cnt += 1
    # print str(ases[key])
print cnt

