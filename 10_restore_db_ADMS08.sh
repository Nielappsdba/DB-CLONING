DATE_TIME=`date +%d%b%H%M`
export DATE_TIME
export NLS_DATE_FORMAT=mm-dd-yyyy hh24:mi:ss

#RESTORE_DATE="05-30-2021 05:55:00"
#RESTORE_DATE="08-04-2021 21:02:00"
RESTORE_DATE="01-20-2022 21:39:00"

rman auxiliary / <<EOF
spool msglog to '/c08/restore/Restore_ADMS08_Duplicate_DB_$DATE_TIME.log';
run
{
allocate auxiliary channel t01 device type disk;
allocate auxiliary channel t02 device type disk;
allocate auxiliary channel t03 device type disk;
allocate auxiliary channel t04 device type disk;
allocate auxiliary channel t05 device type disk;
allocate auxiliary channel t06 device type disk;
allocate auxiliary channel t07 device type disk;
allocate auxiliary channel t08 device type disk;
allocate auxiliary channel t09 device type disk;
allocate auxiliary channel t10 device type disk;
allocate auxiliary channel t11 device type disk;
allocate auxiliary channel t12 device type disk;
allocate auxiliary channel t13 device type disk;
allocate auxiliary channel t14 device type disk;
allocate auxiliary channel t15 device type disk;
allocate auxiliary channel t16 device type disk;
duplicate target database to ADMS08 UNTIL TIME "TO_DATE('$RESTORE_DATE','mm-dd-yyyy hh24:mi:ss')"  backup location '/IBMORABKPPRD/ADMS/' nofilenamecheck;
release channel t01;
release channel t02;
release channel t03;
release channel t04;
release channel t05;
release channel t06;
release channel t07;
release channel t08;
release channel t09;
release channel t10;
release channel t11;
release channel t12;
release channel t13;
release channel t14;
release channel t15;
release channel t16;
}
EOF
exit
