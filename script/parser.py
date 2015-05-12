#!/usr/bin/env python
import re
import sys
import getopt

ases = {}; # a dictionary of ASes, AS number as the key
show_each_AS = False;
show_paths = False;

class AS:
    number = None;
    visited = None;
    paths = None;
    bottelneck = None;
    hasDisjoint = None;
    disjointPaths = None;
    numberOfPaths = None;
    averagePathLength = None;

    def __init__(self, num):
        # print "AS created",num
        self.number = num;
        self.visited = False;
        self.paths = [];
        self.bottelneck = set([]);
        #self.hasDisjoint = False;
        self.numberOfPaths = 0;
        self.averagePathLength = 0.0;
        
    def __str__(self):
        tmp = str(self.number) + " " + str(self.hasDisjoint) + " " + str(self.disjointPaths);
        if show_each_AS:
            tmp += " " + str(self.averagePathLength);
        if show_paths:
            tmp += " " + str(self.paths);
        # tmp = str(self.number) + str(self.paths) + str(self.bottelneck) + str(self.hasDisjoint);
        return tmp

    def shortCut(self):
        i = 0;
        j = len(self.paths)-1;
        while i<j:
            seti = set(self.paths[i][:-1]);
            if seti.isdisjoint(set(self.paths[j][:-1])):
                self.hasDisjoint = True;
                self.disjointPaths = [self.paths[i], self.paths[j]];
                return True;
            i += 1;
            j -= 1;
        self.hasDisjoint = False;
        return False;

    def findDisjoint(self):
        if self.hasDisjoint == False:
            return
        # if it contains only one path or no path
        if len(self.paths) < 2:
            self.hasDisjoint = False;
            return;

        if self.numberOfPaths >= 10000:
            return self.shortCut();
        
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
                    allPaths = None;
                    allowedPathIdSets = None;
                    return True;
            else:
                for asn in allowedPathIdSets:
                    # print pathSets[key];
                    allowedPathIdSets[asn].discard(pid)
        # print "no disjoint path"
        self.hasDisjoint = False;
        allPaths = None;
        allowedPathIdSets = None;
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
                self.numberOfPaths += 1;
                self.averagePathLength += len(path);
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
        # print self.numberOfPaths;
        self.findDisjoint();
        if self.numberOfPaths != 0:
            self.averagePathLength /= self.numberOfPaths;
        self.visited = True

def show():
    global ases;
    cnt = 0;
    numberOfASes = 0;
    averageLength = 0;
    for key in ases:
        numberOfASes += 1;
        averageLength += ases[key].averagePathLength;
        if ases[key].hasDisjoint:
            cnt += 1;
        # print str(ases[key])
    averageLength /= numberOfASes; 
    print cnt;
    print averageLength;
    if show_each_AS:
        print "show AS"
        for each_AS in ases:
            print str(ases[each_AS]);
    if show_paths:
        print "show paths"

def main():
    global ases, show_each_AS, show_paths;
    ribs=None;
    
    try:
        options,args = getopt.getopt(sys.argv[1:],"dp",[])
    except getopt.GetoptError:
        sys.exit()

    for name,value in options:
        if name in ("-d"):
            show_each_AS = True;
            # print "debug"
        if name in ("-p"):
            show_paths = True;
            # print "show paths"

    if len(args) > 0:
        ribs=open(args[0]).read().split('\n')
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
        
    show();


if __name__ == "__main__":
    main()
