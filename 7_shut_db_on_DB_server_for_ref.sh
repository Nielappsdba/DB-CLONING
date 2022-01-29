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

ps -ef|grep pmon

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

ps -ef|grep pmon| grep -v grep | grep -i S08

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

sqlplus -s / as sysdba <<EOF
select name from v\$database;
EOF

echo -e "Are You Sure to shut down Database : $ORACLE_SID 

Continue [y/n]:\c"; read yn

test "$yn" = "Y" || { echo -e "\nNot executing $cmd"; exit; }

sqlplus -s / as sysdba <<EOF
shut immediate
EOF

echo "Database $ORACLE_SID is Shutdown Successfully..."

ps -ef|grep pmon| grep -v grep | grep -i S08


echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ps -ef|grep pmon| grep -v grep
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
