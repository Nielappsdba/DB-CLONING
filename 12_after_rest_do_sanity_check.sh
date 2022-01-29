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

echo -e "Are You Sure to shut down application : $ORACLE_SID

Continue [y/n]:\c"; read yn

test "$yn" = "Y" || { echo -e "\nNot executing $cmd"; exit; }


sqlplus -s / as sysdba <<EOF
select name from v\$database;
shut immediate
EOF


ps -ef|grep pmon
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ps -ef|grep pmon| grep -v grep | grep -i S08

sqlplus -s / as sysdba <<EOF
startup
select name,open_mode from v\$database;
shut immediate
EOF

ps -ef|grep pmon
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ps -ef|grep pmon| grep -v grep | grep -i S08

