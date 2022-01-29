#!/bin/bash

. /c08/db/tech_st/12.1.0/ADMS08_uq00342d.env

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo $ORACLE_SID
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

ps -ef|grep pmon

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

ps -ef|grep pmon| grep -v grep | grep -i S08

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

sqlplus -s / as sysdba <<EOF
startup nomount
show parameter spfile
set lines 200
select INSTANCE_NAME,STARTUP_TIME,HOST_NAME from v\$instance;
EOF

