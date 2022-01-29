#!/bin/bash

USID=applmgr
typeset -u yn

if [ $LOGNAME != "$USID" ]
then
        echo "Unix id must be ${USID}"
        exit
fi


. /c02/apps/apps_st/appl/APPSADMS02_uq00342d.env

echo $TWO_TASK


ps -ef|grep pmon|grep -v grep | grep c02

echo 

echo
echo "ADMIN_SCRIPTS_HOME=$ADMIN_SCRIPTS_HOME"
ls -tlr  $ADMIN_SCRIPTS_HOME/adstpall.sh

ps -ef|grep -i c02 | grep applmgr | grep -v grep
ps -ef|grep -i c02 | grep applmgr | grep -v grep  | wc -l

echo -e "Are You Sure to shut down application : $TWO_TASK 

Continue [y/n]:\c"; read yn

test "$yn" = "Y" || { echo -e "\nNot executing $cmd"; exit; }


. $ADMIN_SCRIPTS_HOME/adstpall.sh apps/apps

ps -ef|grep -i c02 | grep applmgr | grep -v grep
