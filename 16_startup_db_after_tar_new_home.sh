#!/bin/bash
. /c02/db/tech_st/12.1.0/ADMS02_uq00342d.env

typeset -u yn

USID=oracle

if [ $LOGNAME != "$USID" ]
then
        echo "Unix id must be ${USID}"
        exit
fi


echo $ORACLE_SID

ps -ef|grep pmon

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

ps -ef|grep pmon| grep -v grep | grep -i S02

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"


sqlplus -s / as sysdba <<EOF
startup
select name from v\$database;
EOF

ps -ef|grep pmon
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ps -ef|grep pmon| grep -v grep | grep -i S02

