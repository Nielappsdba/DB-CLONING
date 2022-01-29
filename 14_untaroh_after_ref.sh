#!/bin/bash
##############################################################################
#Use this Script to Untar ORACLE_HOME for Cloning. Change the file1 parameter#
##############################################################################

file1=tech_st_Jan2122.tar.gz
cnloc=/u02/CLONE_HOME/ADMS08

typeset -u yn

echo "==============================================="
echo "===================================="

cd /c08/db
pwd

echo
echo "==============================================="
echo "====================================="
ls -ltr



echo "============================================"
echo "========================"
echo "============================================="

echo "tar -xvzf $cnloc/$file1 "
ls -ltr $cnloc/$file1

echo
echo

echo -e "About to execute to tar for $ORACLE_SID :`pwd`
Continue [y/n]:\c"; read yn

test "$yn" = "Y" || { echo -e "\nNot executing $cmd"; exit; }

tar -xvzf $cnloc/$file1  

ls -ltr /c08/db/
