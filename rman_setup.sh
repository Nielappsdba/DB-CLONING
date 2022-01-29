#!/bin/ksh

###############################################################################
# get_pass_cat()
###############################################################################
get_pass_cat()
{
if [ -f  "$RMAN_DIR/SAPNonPRD.CN" ]
then
	ls -la $RMAN_DIR/SAPNonPRD.CN
	cat $RMAN_DIR/SAPNonPRD.CN
	CATALOG=`cat $RMAN_DIR/SAPNonPRD.CN | grep -i catalog | sed 's/connect//g'`
	echo "CATALOG = $CATALOG"
else
	echo "File  $RMAN_DIR/SAPNonPRD.CN does not exist" | tee -a $LOG
	echo "Please create file to register the database"
fi
if [ -z "$CATALOG" ]
then 
	echo "CATALOG variable is not set" | tee -a $LOG
fi

}

###############################################################################
# rman_reg_db()
###############################################################################
rman_reg_db()
{
rman TARGET / $CATALOG <<-EOF
register database;
EOF
}

###############################################################################
# show_all()
###############################################################################
show_all()
{
rman TARGET / $CATALOG <<-EOF
show all; 
EOF
}


###############################################################################
# set_all()
###############################################################################
set_all()
{
echo "PLEASE MAKE SURE YOU HAVE SAVED RMAN CONFIG BEFORE YOU DID THE RESTORE" 
echo "COPY AND PASTE RMAN CONFIGURATION AND THEN RUN THIS OPTION "
rman TARGET / $CATALOG <<-EOF
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 20 DAYS;
CONFIGURE BACKUP OPTIMIZATION OFF;
CONFIGURE DEFAULT DEVICE TYPE TO DISK;
CONFIGURE CONTROLFILE AUTOBACKUP ON;
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '/IBMORABKPNONPRD/$ORACLE_SID/$ORACLE_SID_CTL_%F';
CONFIGURE DEVICE TYPE DISK PARALLELISM 4 BACKUP TYPE TO BACKUPSET;
CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE DISK TO 1;
CONFIGURE ARCHIVELOG BACKUP COPIES FOR DEVICE TYPE DISK TO 1;
CONFIGURE MAXSETSIZE TO UNLIMITED;
CONFIGURE ENCRYPTION FOR DATABASE OFF;
CONFIGURE ENCRYPTION ALGORITHM 'AES128';
CONFIGURE COMPRESSION ALGORITHM 'BASIC' AS OF RELEASE 'DEFAULT' OPTIMIZE FOR LOAD TRUE ; # default
CONFIGURE RMAN OUTPUT TO KEEP FOR 7 DAYS; # default
CONFIGURE ARCHIVELOG DELETION POLICY TO NONE;
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '$ORACLE_HOME/dbs/snapcf_gqmsrd.f';
show all; 
EOF
}



##############################################################################
# display_menu1
##############################################################################
display_menu1()
{
while true
do
tput clear

cat <<-EOF
             ORACLE_HOME = $ORACLE_HOME
1. Register database for $ORACLE_SID
2. Set Config Parameter 
3. Show all Parameters 
999.Exit                                    
EOF


printf "Enter number: "
read num

case "$num" in

	 1) get_pass_cat
            rman_reg_db
	   ;;
	 2) get_pass_cat
            set_all
	   ;;
	 3) get_pass_cat
            show_all
	   ;;
	999) echo "Good-Bye $LOGNAME" 
	     exit
	   ;;
	*) echo "Invalid Option"
	   ;;
esac

printf "Enter <CR> to continue: "
read j
done
}

##############################################################################
# MAIN PROGRAM
##############################################################################

DIR=/u02
TNS_ADMIN=$DIR/rman/network/admin; export TNS_ADMIN
RMAN_DIR=$DIR/rman

DT=`date "+%m_%d_%y"`
LOG=/tmp/rman_setup.log
rm -f $LOG

if [ -z "$ORACLE_HOME" ]
then
	echo "ORACLE_HOME is not set"
	exit
fi

echo "Running $0 at [`date`] for database $ORACLE_HOME "  | tee -a $LOG
display_menu1

