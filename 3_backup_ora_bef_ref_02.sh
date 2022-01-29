#!/bin/bash

####################################################################
#Take the backup of tnsname,listener,initsid,contextfile(.xml) files#
#####################################################################


ls -tlr /c08/db/tech_st/12.1.0/ADMS08_uq00342d.env
env_file=/c08/db/tech_st/12.1.0/ADMS08_uq00342d.env


if [ ! -f $env_file ]

then
echo "Env File not found!"
echo "$env_file"
echo "Bye...Bye...."
exit
fi


. /c08/db/tech_st/12.1.0/ADMS08_uq00342d.env

echo "=========================================================="
echo "ORACLE_HOME" 
echo "$ORACLE_HOME"
echo "=========================================================="
echo "ORACLE_SID"
echo "$ORACLE_SID"
echo "=========================================================="

cnloc=/u02/CLONE_HOME/ADMS08
cd $cnloc

pwd

echo "cp /c08/db/tech_st/12.1.0/network/admin/${ORACLE_SID}_uq00342d/listener.ora ."
echo "cp /c08/db/tech_st/12.1.0/network/admin/${ORACLE_SID}_uq00342d/tnsnames.ora ." 
echo "cp /c08/db/tech_st/12.1.0/dbs/init${ORACLE_SID}.ora ."
echo "cp /c08/db/tech_st/12.1.0/dbs/spfile${ORACLE_SID}.ora ."
echo "cp /c08/db/tech_st/12.1.0/appsutil/${ORACLE_SID}_uq00342d.xml ."
echo "cp /c08/inst/apps/${ORACLE_SID}_uq00342d/appl/admin/${ORACLE_SID}_uq00342d.xml ." 
echo "cp /c08/db/tech_st/12.1.0/${ORACLE_SID}_uq00342d.env ."
cp /c08/db/tech_st/12.1.0/network/admin/${ORACLE_SID}_uq00342d/listener.ora .
cp /c08/db/tech_st/12.1.0/network/admin/${ORACLE_SID}_uq00342d/tnsnames.ora . 
cp /c08/db/tech_st/12.1.0/dbs/init${ORACLE_SID}.ora .
cp /c08/db/tech_st/12.1.0/dbs/spfile${ORACLE_SID}.ora .
cp /c08/db/tech_st/12.1.0/appsutil/${ORACLE_SID}_uq00342d.xml .
cp /c08/inst/apps/${ORACLE_SID}_uq00342d/appl/admin/${ORACLE_SID}_uq00342d.xml .
cp /c08/db/tech_st/12.1.0/${ORACLE_SID}_uq00342d.env .

ls -ltr $cnloc
