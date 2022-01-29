#!/bin/bash
. /c08/db/tech_st/12.1.0/ADMS08_uq00342d.env

typeset -u yn

USID=oracle

if [ $LOGNAME != "$USID" ]
then
        echo "Unix id must be ${USID}"
        exit
fi


echo $ORACLE_SID
echo $ORACLE_HOME

ps -ef|grep pmon

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

ps -ef|grep pmon| grep -v grep | grep -i S08

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

sqlplus -s / as sysdba <<EOF
startup mount exclusive restrict; 
select name from v\$database;
EOF


echo -e "Are You Sure to DROP Database : $ORACLE_SID

Continue [y/n]:\c"; read yn

test "$yn" = "Y" || { echo -e "\nNot executing $cmd"; exit; }


sqlplus -s / as sysdba <<EOF
select name from v\$database;
drop database;    
EOF

echo "Database $ORACLE_SID is DROP Successfully..."

ps -ef|grep pmon| grep -v grep | grep -i S08
ps -ef|grep tns|grep -v grep | grep $ORACLE_SID


echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

ls -ltr /c08/oradata/ADMS08/
du -sh /c08/oradata/ADMS08/*
