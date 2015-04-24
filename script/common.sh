#!/bin/bash
# author: wudanzy@csnet1.cs.tsinghua.edu.cn
# create: Jan 2014
# update: Apr 2015
#
# All basic settings 
#

BASE_DIR="../"
DATA_DIR=$BASE_DIR"data/"
SRC_DIR=$BASE_DIR"src/"
SHELL_DIR=$BASE_DIR"script/"

log_debug() { current=`date "+%b %d %T"`; echo -e "[$current] $1"; }
clean_dir() { if [ -e $1 ]; then rm -rf $1; fi; mkdir -p $1; }
check_dir() { mkdir -p $1; }
