LONE_README.txt


Three Phase for Database & Application Clonning

Phase :1  Take  Backup of ORACLE_HOME & APPLICATION HOME

1: Take Backup of ORACLE_HOME
On Production Server uq00392p
login as oracle user.
cd /home/oracle/JOHN
./1_taroh_for_clone.sh

2: Login as applmgr@uq00392p
. /c00/apps/apps_st/appl/APPSADMS_uq00392p.env

echo $TWO_TASK

cd /home/applmgr
./2_tar_appoh_for_clone.sh

Please Exist from Production Server. 

====================================================================================================================
PHASE :2 DATABASE TIER CLONING.

login on Server uq00342d as User oracle

Take Backup of Spfile,tns.ora,listenere.ora,context file

. /c08/db/tech_st/12.1.0/ADMS08_uq00342d.env
echo $ORACLE_SID

cd /home/oracle/ADMS08
3 ./3_backup_ora_bef_ref_02.sh

On Server uq00342d login as applmgr please run below script to take backup of context file.
. /c08/apps/apps_st/appl/APPSADMS08_uq00342d.env
echo $TWO_TASK
cd /home/applmgr/ADMS08
./3_backup_context_bef_ref_02.sh

on Server cuz103567d as applmgr please run below script to take backup of context file.
. /c08/apps/apps_st/appl/APPSADMS08_cuz103567d.env
echo $TWO_TASK

cd /home/applmgr/ADMS08/CLONE
./3_backup_cont_before_ref.sh


+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Shut Down the Application Server & Mobile Service.

On App server cuz103567d login as applmgr

. /c08/apps/apps_st/appl/APPSADMS08_cuz103567d.env
echo $TWO_TASK

cd /home/applmgr/ADMS08/CLONE
4 ./4_shut_app_onapp_server_for_ref.sh

On App server cuz103567d login as applmgr & shut down Mobile Server.
cd /home/applmgr  
echo $TWO_TASK
5 ./MWA_STOP.sh

Check Status 
echo "ps -ef|grep -i ${TWO_TASK} | grep applmgr | grep -v grep"
ps -ef|grep -i ${TWO_TASK} | grep applmgr | grep -v grep
ps -ef|grep -i ADMS08 | grep applmgr | grep -v grep
ps -ef|grep mwa | grep -i c08

Note: Please COnfirm All process should be down for ADMS08 Instance.


On DB Server uq00342d Login as applmgr and shut down the application
. /c08/apps/apps_st/appl/APPSADMS08_uq00342d.env
echo $TWO_TASK

cd /home/applmgr/ADMS08
6 ./6_shut_app_ondb_server_for_ref.sh

ps -ef|grep -i c08 | grep applmgr | grep -v grep

NOTE: Please wait for some time, application process take some time for complete shut down.

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
On DB Server uq00342d Login as oracle id and shut down the Database.

. /c08/db/tech_st/12.1.0/ADMS08_uq00342d.env
echo $ORACLE_SID
cd /home/oracle/ADMS08

7 ./7_shut_db_on_DB_server_for_ref.sh

. /c08/db/tech_st/12.1.0/ADMS08_uq00342d.env
echo $ORACLE_HOME
echo $ORACLE_SID
cd $ORACLE_HOME/dbs
ls -ltr *ADMS08*

ls spfile$ORACLE_SID.ora
ls init$ORACLE_SID.ora

cp spfile$ORACLE_SID.ora spfile$ORACLE_SID.ora_bkp_ref
cp init$ORACLE_SID.ora init$ORACLE_SID.ora_bkp_ref

ls -ltr init$ORACLE_SID.ora_bkp_ref
ls -ltr spfile$ORACLE_SID.ora_bkp_ref


Drop Database for refresh.
cd /home/oracle/ADMS08

8 ./8_drop_db_for_clone_for_ref.sh 

Startup Database in NoMount.
9  ./9_start_db_nomount_for_ref.sh


Before execute this command please add db_file_name_convert & log_file_name_convert
vi $ORACLE_HOME/dbs/initADMS08.ora

*.db_file_name_convert='/c00/oradata/ADMS','/c08/oradata/ADMS08'
*.log_file_name_convert='/c00/oradata/ADMS','/c08/oradata/ADMS08'

sqlplus / as sysdba
show parameter db_file_name_convert
show parameter log_file_name_convert



Restore Database using 
10 ./10_restore_db_ADMS08.sh

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
TYPICALLY DB RESTORE TAKE 4-5 Hours , SO DURING THAT TIME  YOu CAN COPIED PRODUCTION
ORACLE_HOME & APPLICATION_HOME.

LOGIN ON SERVER uq00342d as ORACLE user.
cd /home/oracle/ADMS08
ftptaroh_for_clone.sh 

LOGIN ON SERVER uq00342d as applmgr users.
cd /home/applmgr/ADMS08
./ftpappoh_for_clone.sh

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

After Restore Add temp tablespace.
11 ./11_after_rest_add_temp_file.sh ====> No need in our Case. Temp file already created.
for conformation please login to Database and use ==> select FILE_NAME ,TABLESPACE_NAME from dba_temp_files;


Shut Down Database.
12 ./12_after_rest_do_sanity_check.sh

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
cd /home/oracle/ADMS08

Now Remove the ORACLE_HOME ,Login on uq00342d as oracle user.
13 ./13_remove_oh_for_clone_aft_ref.sh

Untar the production Database ORACLE_HOME on Dev Server.
14 ./14_untaroh_after_ref.sh

Copy the Listener,ORA to New Home
15 ./15_copy_tns_list_ora_file_tooh_after_ref.sh

Startup Database with New Home.Manually with pfile 
16 ./16_startup_db_after_tar_new_home.sh===> DOnt use this Script 

sqlplus / as sysdba
startup nomount pfile="/c08/db/tech_st/12.1.0/dbs/initADMS08.ora";
create spfile from pfile;
shut immediate
startup
select name,open_mode from v$database;

lsnrctl stop ADMS08
lsnrctl start ADMS08

NOTE:-ORA-07446: sdnfy: bad value '/c08/db/tech_st/diag/rdbms/adms02/ADMS08/trace'==> To avoid this error please use
above steps.



18 Configure the Oracle Home and Context file
export ORACLE_BASE=/c08/db/tech_st
export ORACLE_HOME=/c08/db/tech_st/12.1.0
export LD_LIBRARY_PATH=/c08/db/tech_st/12.1.0/lib
export PERL5LIB=/c08/db/tech_st/12.1.0/perl/lib
export PATH=/c08/db/tech_st/12.1.0/perl/bin:$PATH
export PATH=/c08/db/tech_st/12.1.0/bin:$PATH
/c08/db/tech_st/12.1.0/perl/bin/perl /c08/db/tech_st/12.1.0/nls/data/old/cr9idata.pl
export ORA_NLS10=/c08/db/tech_st/12.1.0/nls/data/9idata
export PATH=/c08/db/tech_st/12.1.0/OPatch:$PATH
cd /c08/db/tech_st/12.1.0/appsutil/bin/
echo $ORACLE_SID
perl adbldxml.pl appsuser=apps

###############################################################################################################
#The log file for this adbldxml session is located at:
#/c08/db/tech_st/12.1.0/appsutil/log/adbldxml_04222324.log
#AC-20010: Error: File - listener.ora could not be found at the location:====You will get message u can ignorei#
#        /c08/db/tech_st/12.1.0/network/admin/ADMS08_uq00342d/listener.ora
#indicated by TNS_ADMIN. Context file can not be generated.
#Could not Connect to the Database with the above parameters, Please answer the Questions below
#################################################################################################################

####################################################################################
# Use this answer when you run above command ==>perl adbldxml.pl appsuser=apps
Enter Hostname of Database server: uq00342d
Enter Port of Database server: 1529
Enter SID of Database server: ADMS08
Enter the value for Display Variable: uq00342d:0.0
The context file has been created at:
/c08/db/tech_st/12.1.0/appsutil/ADMS08_uq00342d.xml

#######################################################################################

cd /c08/db/tech_st/12.1.0/appsutil/bin
sh adconfig.sh	-- Enter the full path of Context file from the previous step



cd /c08/db/tech_st/12.1.0/appsutil/bin
sh adconfig.sh  -- Enter the full path of Context file from the previous step

##########################################################################################################################################################
#Enter the full path to the Context file: /c08/db/tech_st/12.1.0/appsutil/ADMS08_uq00342d.xml
#Enter the APPS user password:
#The log file for this session is located at: /c08/db/tech_st/12.1.0/appsutil/log/ADMS08_uq00342d/04221831/adconfig.log
#AutoConfig is configuring the Database environment...
#AutoConfig will consider the custom templates if present.
#        Using ORACLE_HOME location : /c08/db/tech_st/12.1.0
 #       Classpath                   : :/c08/db/tech_st/12.1.0/jdbc/lib/ojdbc6.jar:/c08/db/tech_st/12.1.0/appsutil/java/xmlparserv2.jar:/c08/db/tech_st/12.1.0/appsutil/java:/c08/db/tech_st/12.1.0/jlib/netcfg.jar:/c08/db/tech_st/12.1.0/jlib/ldapjclnt12.jar
#        Using Context file          : /c08/db/tech_st/12.1.0/appsutil/ADMS08_uq00342d.xml
#Context Value Management will now update the Context file
#        Updating Context file...COMPLETED
 #       Attempting upload of Context file and templates to database...COMPLETED
#Updating rdbms version in Context file to db121
#Updating rdbms type in Context file to 64 bits
#Configuring templates from ORACLE_HOME ...
#AutoConfig completed successfully.
#
################################################################################################################################################################

Clear the fnd_nodes table and Run autoconfig
sqlplus apps/apps
select node_name from fnd_nodes;
exec fnd_conc_clone.setup_clean;
exit
=====================================================================================================================================================
run autoconfig 	database server,database app server, app server
cd /c08/db/tech_st/12.1.0/appsutil/scripts/ADMS08_uq00342d
sh adautocfg.sh         -- Enter the apps password when prompted

Enter the APPS user password:
The log file for this session is located at: /c08/db/tech_st/12.1.0/appsutil/log/ADMS08_uq00342d/06041140/adconfig.log

AutoConfig is configuring the Database environment...

AutoConfig will consider the custom templates if present.
        Using ORACLE_HOME location : /c08/db/tech_st/12.1.0
        Classpath                   : :/c08/db/tech_st/12.1.0/jdbc/lib/ojdbc6.jar:/c08/db/tech_st/12.1.0/appsutil/java/xmlparserv2.jar:/c08/db/tech_st/12.1.0/appsutil/java:/c08/db/tech_st/12.1.0/jlib/netcfg.jar:/c08/db/tech_st/12.1.0/jlib/ldapjclnt12.jar

        Using Context file          : /c08/db/tech_st/12.1.0/appsutil/ADMS08_uq00342d.xml

Context Value Management will now update the Context file

        Updating Context file...COMPLETED

        Attempting upload of Context file and templates to database...COMPLETED

Updating rdbms version in Context file to db121
Updating rdbms type in Context file to 64 bits
Configuring templates from ORACLE_HOME ...

AutoConfig completed successfully.

=======================================================================================================================================================

Step 19.
As the last step, shutdown and bring up the database and listener, both

sqlplus / as sysdba
select name,open_mode from v$database;
shut immediate
startup
exit
lsnrctl status ADMS08
lsnrctl stop ADMS08
lsnrctl start ADMS08
==========================================================================================
PHASE 3: APPLICATION TIER CLONING.

20  Login as applmgr on uq00342d
cd /home/applmgr/ADMS08
./17_after_db_refresh_remove_applho.sh


21 Untar the production Database ORACLE_APPS_HOME on Dev Server.
21_untar_appoh_after_ref.sh

22.cd /c08/apps/apps_st/comn/clone/bin
run this command ==>perl adcfgclone.pl appsTier
==========================================================================================================================
[applmgr@uq00342d bin]$ perl adcfgclone.pl appsTier

                     Copyright (c) 2002 Oracle Corporation
                        Redwood Shores, California, USA

                        Oracle Applications Rapid Clone

                                 Version 12.0.0

                      adcfgclone Version 120.31.12010000.8

Enter the APPS password :

Running:
/c08/apps/apps_st/comn/clone/bin/../jre/bin/java -Xmx600M -cp /c08/apps/apps_st/comn/clone/jlib/java:/c08/apps/apps_st/comn/clone/jlib/xmlparserv2.jar:/c08/apps/apps_st/comn/clone/jlib/ojdbc14.jar oracle.apps.ad.context.CloneContext -e /c08/apps/apps_st/comn/clone/bin/../context/apps/CTXORIG.xml -validate -pairsfile /tmp/adpairsfile_30975.lst -stage /c08/apps/apps_st/comn/clone  2> /tmp/adcfgclone_30975.err; echo $? > /tmp/adcfgclone_30975.res

Log file located at /c08/apps/apps_st/comn/clone/bin/CloneContext_0423022604.log

Provide the values required for creation of the new APPL_TOP Context file.

Target System Hostname (virtual or normal) [uq00342d] :

Target System Database SID : ADMS08

Target System Database Server Node [uq00342d] :

Target System Database Domain Name [oneabbott.com] :

Target System Base Directory : /c08

Target System Tools ORACLE_HOME Directory [/c08/apps/tech_st/10.1.2] :

Target System Web ORACLE_HOME Directory [/c08/apps/tech_st/10.1.3] :

Target System APPL_TOP Directory [/c08/apps/apps_st/appl] :

Target System COMMON_TOP Directory [/c08/apps/apps_st/comn] :

Target System Instance Home Directory [/c08/inst] :

Target System Root Service [disabled] :

Target System Web Entry Point Services [disabled] :

Target System Web Application Services [disabled] :

Target System Batch Processing Services [enabled] :

Target System Other Services [enabled] : disabled

Do you want to preserve the Display [dalol021:0.0] (y/n)  : n

Target System Display [uq00342d:0.0] :

Do you want the the target system to have the same port values as the source system (y/n) [y] ? : n

Target System Port Pool [0-99] : 2

Checking the port pool 2
RC-50221: Warning: Port Pool 2 is not free. Please check logfile /c08/apps/apps_st/comn/clone/bin/CloneContext_0423022604.log for conflicts.

Target System Port Pool [0-99] : 8

Checking the port pool 8
done: Port Pool 8 is free
Report file located at /c08/inst/apps/ADMS08_uq00342d/admin/out/portpool.lst
Complete port information available at /c08/inst/apps/ADMS08_uq00342d/admin/out/portpool.lst

UTL_FILE_DIR on database tier consists of the following directories.

1. /usr/tmp
2. /c08/db/tech_st/11.2.0/appsutil/outbound/ADMS08_uq00342d
3. /c08/inst/apps/ADMS08_uq00342d/applptmp
4. /c08/inst/apps/ADMS08_uq00342d/appltmp
5. /transfer/loftware
6. /TRANSFER/edi/out
7. *
Choose a value which will be set as APPLPTMP value on the target node [1] :

Creating the new APPL_TOP Context file from :
  /c08/apps/apps_st/appl/ad/12.0.0/admin/template/custom/adxmlctx.tmp

The new APPL_TOP context file has been created :
  /c08/inst/apps/ADMS08_uq00342d/appl/admin/ADMS08_uq00342d.xml

Log file located at /c08/apps/apps_st/comn/clone/bin/CloneContext_0423022604.log
Check Clone Context logfile /c08/apps/apps_st/comn/clone/bin/CloneContext_0423022604.log for details.

Running Rapid Clone with command:
perl /c08/apps/apps_st/comn/clone/bin/adclone.pl java=/c08/apps/apps_st/comn/clone/bin/../jre mode=apply stage=/c08/apps/apps_st/comn/clone component=appsTier method=CUSTOM appctxtg=/c08/inst/apps/ADMS08_uq00342d/appl/admin/ADMS08_uq00342d.xml showProgress contextValidated=true
Running:
perl /c08/apps/apps_st/comn/clone/bin/adclone.pl java=/c08/apps/apps_st/comn/clone/bin/../jre mode=apply stage=/c08/apps/apps_st/comn/clone component=appsTier method=CUSTOM appctxtg=/c08/inst/apps/ADMS08_uq00342d/appl/admin/ADMS08_uq00342d.xml showProgress contextValidated=true
APPS Password :

Beginning application tier Apply - Thu Apr 22 23:11:02 2021

/c08/apps/apps_st/comn/clone/bin/../jre/bin/java -Xmx600M -DCONTEXT_VALIDATED=true  -Doracle.installer.oui_loc=/oui -classpath /c08/apps/apps_st/comn/clone/jlib/xmlparserv2.jar:/c08/apps/apps_st/comn/clone/jlib/ojdbc14.jar:/c08/apps/apps_st/comn/clone/jlib/java:/c08/apps/apps_st/comn/clone/jlib/oui/OraInstaller.jar:/c08/apps/apps_st/comn/clone/jlib/oui/ewt3.jar:/c08/apps/apps_st/comn/clone/jlib/oui/share.jar:/c08/apps/apps_st/comn/clone/jlib/oui/srvm.jar:/c08/apps/apps_st/comn/clone/jlib/ojmisc.jar  oracle.apps.ad.clone.ApplyAppsTier -e /c08/inst/apps/ADMS08_uq00342d/appl/admin/ADMS08_uq00342d.xml -stage /c08/apps/apps_st/comn/clone    -showProgress
APPS Password : Log file located at /c08/inst/apps/ADMS08_uq00342d/admin/log/ApplyAppsTier_04230411.log
  \     83% completed

Completed Apply...
Thu Apr 22 23:16:19 2021


Do you want to startup the Application Services for ADMS08? (y/n) [y] : n

Services not started


===========================================================================================================================

This below Steps if the Port is busy and used by other process.

[applmgr@uq00342d bin]$ perl adcfgclone.pl appsTier



                     Copyright (c) 2002 Oracle Corporation
                        Redwood Shores, California, USA

                        Oracle Applications Rapid Clone

                                 Version 12.0.0

                      adcfgclone Version 120.31.12010000.8

Enter the APPS password :

Running:
/c08/apps/apps_st/comn/clone/bin/../jre/bin/java -Xmx600M -cp /c08/apps/apps_st/comn/clone/jlib/java:/c08/apps/apps_st/comn/clone/jlib/xmlparserv2.jar:/c08/apps/apps_st/comn/clone/jlib/ojdbc14.jar oracle.apps.ad.context.CloneContext -e /c08/apps/apps_st/comn/clone/bin/../context/apps/CTXORIG.xml -validate -pairsfile /tmp/adpairsfile_19584.lst -stage /c08/apps/apps_st/comn/clone  2> /tmp/adcfgclone_19584.err; echo $? > /tmp/adcfgclone_19584.res

Log file located at /c08/apps/apps_st/comn/clone/bin/CloneContext_0408141754.log

Provide the values required for creation of the new APPL_TOP Context file.

Target System Hostname (virtual or normal) [uq00342d] :

Target System Database SID : ADMS08

Target System Database Server Node [uq00342d] :

Target System Database Domain Name [oneabbott.com] :

Target System Base Directory : /c08

Target System Tools ORACLE_HOME Directory [/c08/apps/tech_st/10.1.2] :

Target System Web ORACLE_HOME Directory [/c08/apps/tech_st/10.1.3] :

Target System APPL_TOP Directory [/c08/apps/apps_st/appl] :

Target System COMMON_TOP Directory [/c08/apps/apps_st/comn] :

Target System Instance Home Directory [/c08/inst] :

Target System Root Service [disabled] :

Target System Web Entry Point Services [disabled] :

Target System Web Application Services [disabled] :

Target System Batch Processing Services [enabled] :

Target System Other Services [enabled] : disabled

Do you want to preserve the Display [dalol021:0.0] (y/n)  : n

Target System Display [uq00342d:0.0] :

Do you want the the target system to have the same port values as the source system (y/n) [y] ? : n

Target System Port Pool [0-99] : 7

Checking the port pool 2
RC-50221: Warning: Port Pool 2 is not free. Please check logfile /c08/apps/apps_st/comn/clone/bin/CloneContext_0408141754.log for conflicts.

Target System Port Pool [0-99] : ^C=====> Here we got error , 
======================================================================================================================
So to Resolve this issue , Please do below steps.
check this log /c08/apps/apps_st/comn/clone/bin/CloneContext_0408141754.log

RC-50204: Error: - OC4J RMI Port Range for Forms-c4ws in use: Port Value = 27514===> for this port we got issue
so we checked who accesssing this Port using lsof command.


So please cancel this command. & use the Backup context file of the location
cd /home/applmgr/ADMS08
cp ADMS08_uq00342d.xml ADMS08_uq00342d.xml_bkp

<forms-c4ws_rmi_portrange oa_var="s_forms-c4ws_rmi_portrange" oa_type="PORT" base="27500" step="5" 
range="5" label="OC4J RMI Port Range for Forms-c4ws">27515-27519</forms-c4ws_rmi_portrange> ----> use this range & in
cloning Video Amrita did change the Value.



To check the Port use command
lsof -i TCP:27514

Look for LISTENE
java    44001 applmgr   23u  IPv6 72062152      0t0  TCP uq00342d.oneabbott.com:27514 (LISTEN)

ps -ef|grep 44001 ===> You will get who accessing the process.

=======================================================================================================================

Solution for Above issue

[applmgr@uq00342d bin]$ pwd
/c08/apps/apps_st/comn/clone/bin
[applmgr@uq00342d bin]$ perl adcfgclone.pl appsTier /home/applmgr/ADMS08/ADMS08_uq00342d.xml

                     Copyright (c) 2002 Oracle Corporation
                        Redwood Shores, California, USA

                        Oracle Applications Rapid Clone

                                 Version 12.0.0

                      adcfgclone Version 120.31.12010000.8

Enter the APPS password :


Running Rapid Clone with command:
perl /c08/apps/apps_st/comn/clone/bin/adclone.pl java=/c08/apps/apps_st/comn/clone/bin/../jre mode=apply stage=/c08/apps/apps_st/comn/clone component=appsTier method=CUSTOM appctxtg=/home/applmgr/ADMS08/ADMS08_uq00342d.xml showProgress contextValidated=false
Running:
perl /c08/apps/apps_st/comn/clone/bin/adclone.pl java=/c08/apps/apps_st/comn/clone/bin/../jre mode=apply stage=/c08/apps/apps_st/comn/clone component=appsTier method=CUSTOM appctxtg=/home/applmgr/ADMS08/ADMS08_uq00342d.xml showProgress contextValidated=false
APPS Password :

Beginning application tier Apply - Thu Apr  8 09:56:45 2021

/c08/apps/apps_st/comn/clone/bin/../jre/bin/java -Xmx600M -DCONTEXT_VALIDATED=false  -Doracle.installer.oui_loc=/oui -classpath /c08/apps/apps_st/comn/clone/jlib/xmlparserv2.jar:/c08/apps/apps_st/comn/clone/jlib/ojdbc14.jar:/c08/apps/apps_st/comn/clone/jlib/java:/c08/apps/apps_st/comn/clone/jlib/oui/OraInstaller.jar:/c08/apps/apps_st/comn/clone/jlib/oui/ewt3.jar:/c08/apps/apps_st/comn/clone/jlib/oui/share.jar:/c08/apps/apps_st/comn/clone/jlib/oui/srvm.jar:/c08/apps/apps_st/comn/clone/jlib/ojmisc.jar  oracle.apps.ad.clone.ApplyAppsTier -e /home/applmgr/ADMS08/ADMS08_uq00342d.xml -stage /c08/apps/apps_st/comn/clone    -showProgress
APPS Password : Log file located at /c08/inst/apps/ADMS08_uq00342d/admin/log/ApplyAppsTier_04081456.log
  |      0% completed
Log file located at /c08/inst/apps/ADMS08_uq00342d/admin/log/ApplyAppsTier_04081456.log
  -     79% completed

Completed Apply...
Thu Apr  8 09:59:51 2021


Do you want to startup the Application Services for ADMS08? (y/n) [y] : n

Services not started





=========================================================================================================================
LOGIN ON SERVER cuz103567d as applmgr and remove apps from location ==>/c08/inst/apps

cd /home/applmgr/ADMS08/CLONE
./rem_application_file.sh

Start the adcfgclone

cd /c08/apps/apps_st/comn/clone/bin
perl adcfgclone.pl appsTier

[applmgr@cuz103567d CLONE]$ cd /c08/apps/apps_st/comn/clone/bin
[applmgr@cuz103567d bin]$ perl adcfgclone.pl appsTier

                     Copyright (c) 2002 Oracle Corporation
                        Redwood Shores, California, USA

                        Oracle Applications Rapid Clone

                                 Version 12.0.0

                      adcfgclone Version 120.31.12010000.8

Enter the APPS password :

Running:
/c08/apps/apps_st/comn/clone/bin/../jre/bin/java -Xmx600M -cp /c08/apps/apps_st/comn/clone/jlib/java:/c08/apps/apps_st/comn/clone/jlib/xmlparserv2.jar:/c08/apps/apps_st/comn/clone/jlib/ojdbc14.jar oracle.apps.ad.context.CloneContext -e /c08/apps/apps_st/comn/clone/bin/../context/apps/CTXORIG.xml -validate -pairsfile /tmp/adpairsfile_23248.lst -stage /c08/apps/apps_st/comn/clone  2> /tmp/adcfgclone_23248.err; echo $? > /tmp/adcfgclone_23248.res

Log file located at /c08/apps/apps_st/comn/clone/bin/CloneContext_0408102218.log

Provide the values required for creation of the new APPL_TOP Context file.

Target System Hostname (virtual or normal) [cuz103567d] :

Target System Database SID : ADMS08

Target System Database Server Node [cuz103567d] : uq00342d

Target System Database Domain Name [oneabbott.com] :

Target System Base Directory : /c08

Target System Tools ORACLE_HOME Directory [/c08/apps/tech_st/10.1.2] :

Target System Web ORACLE_HOME Directory [/c08/apps/tech_st/10.1.3] :

Target System APPL_TOP Directory [/c08/apps/apps_st/appl] :

Target System COMMON_TOP Directory [/c08/apps/apps_st/comn] :

Target System Instance Home Directory [/c08/inst] :

Target System Root Service [disabled] :

Target System Web Entry Point Services [disabled] : enabled

Target System Web Application Services [disabled] : enabled

Target System Batch Processing Services [enabled] : disabled

Target System Other Services [enabled] : disabled

Do you want to preserve the Display [dalol021:0.0] (y/n)  : n

Target System Display [cuz103567d:0.0] :

Do you want the the target system to have the same port values as the source system (y/n) [y] ? : n

Target System Port Pool [0-99] : 8

Checking the port pool 8
done: Port Pool 2 is free
Report file located at /c08/inst/apps/ADMS08_cuz103567d/admin/out/portpool.lst
Complete port information available at /c08/inst/apps/ADMS08_cuz103567d/admin/out/portpool.lst

UTL_FILE_DIR on database tier consists of the following directories.

1. /usr/tmp
2. /c08/db/tech_st/12.1.0/appsutil/outbound/ADMS08_uq00342d
3. /c08/inst/apps/ADMS08_uq00342d/applptmp
4. /c08/inst/apps/ADMS08_cuz103567d/appltmp
5. /transfer/loftware
6. /TRANSFER/edi/out
7. *
Choose a value which will be set as APPLPTMP value on the target node [1] :

Creating the new APPL_TOP Context file from :
  /c08/apps/apps_st/appl/ad/12.0.0/admin/template/custom/adxmlctx.tmp

The new APPL_TOP context file has been created :
  /c08/inst/apps/ADMS08_cuz103567d/appl/admin/ADMS08_cuz103567d.xml

Log file located at /c08/apps/apps_st/comn/clone/bin/CloneContext_0408102218.log
Check Clone Context logfile /c08/apps/apps_st/comn/clone/bin/CloneContext_0408102218.log for details.

Running Rapid Clone with command:
perl /c08/apps/apps_st/comn/clone/bin/adclone.pl java=/c08/apps/apps_st/comn/clone/bin/../jre mode=apply stage=/c08/apps/apps_st/comn/clone component=appsTier method=CUSTOM appctxtg=/c08/inst/apps/ADMS08_cuz103567d/appl/admin/ADMS08_cuz103567d.xml showProgress contextValidated=true
Running:
perl /c08/apps/apps_st/comn/clone/bin/adclone.pl java=/c08/apps/apps_st/comn/clone/bin/../jre mode=apply stage=/c08/apps/apps_st/comn/clone component=appsTier method=CUSTOM appctxtg=/c08/inst/apps/ADMS08_cuz103567d/appl/admin/ADMS08_cuz103567d.xml showProgress contextValidated=true
APPS Password :

Beginning application tier Apply - Thu Apr  8 10:26:04 2021

/c08/apps/apps_st/comn/clone/bin/../jre/bin/java -Xmx600M -DCONTEXT_VALIDATED=true  -Doracle.installer.oui_loc=/oui -classpath /c08/apps/apps_st/comn/clone/jlib/xmlparserv2.jar:/c08/apps/apps_st/comn/clone/jlib/ojdbc14.jar:/c08/apps/apps_st/comn/clone/jlib/java:/c08/apps/apps_st/comn/clone/jlib/oui/OraInstaller.jar:/c08/apps/apps_st/comn/clone/jlib/oui/ewt3.jar:/c08/apps/apps_st/comn/clone/jlib/oui/share.jar:/c08/apps/apps_st/comn/clone/jlib/oui/srvm.jar:/c08/apps/apps_st/comn/clone/jlib/ojmisc.jar  oracle.apps.ad.clone.ApplyAppsTier -e /c08/inst/apps/ADMS08_cuz103567d/appl/admin/ADMS08_cuz103567d.xml -stage /c08/apps/apps_st/comn/clone    -showProgress
APPS Password : Log file located at /c08/inst/apps/ADMS08_cuz103567d/admin/log/ApplyAppsTier_04081026.log


At Last step Say No to start the application.
Do you want to startup the Application Services for ADMS08? (y/n) [y] : n


========================================================================================================================

PHASE 4: POST CLONING ACTIVITY.

Now Login to Database Server
. /c08/db/tech_st/12.1.0/ADMS08_uq00342d.env
echo $ORACLE_SID


Run the below query by logging in the ADMS08 database as apps user
sqlplus apps/apps
update fnd_concurrent_requests set phase_code='C',status_code='D' where phase_code in ('I','P');
commit;

SQL> update fnd_concurrent_requests set phase_code='C',status_code='D' where phase_code in ('I','P');

519 rows updated.


Bring up the application services on both servers

login as applmgr on Server uq00342d


cd /c08/apps/apps_st/appl
. /c08/apps/apps_st/appl/APPSADMS08_uq00342d.env
echo $TWO_TASK

cd /home/applmgr/ADMS08/
./start_app_ondb_server.sh

=========================================================================================================================
Error:-

if the lisetener is not start then check sqlnet.ora

please add this value.

cd /c08/inst/apps/ADMS08_uq00342d/ora/10.1.2/network/admin
cat sqlnet.ora

tcp.invited_nodes = (CUZ103567D.oneabbott.com, UQ00342D.oneabbott.com)

[applmgr@uq00342d admin]$ ps -ef|grep APPS_ADMS08
applmgr   7610     1  0 00:10 ?        00:00:00 /c08/apps/tech_st/10.1.2/bin/tnslsnr APPS_ADMS08 -inherit

======================================================================================================================================

Login as applmgr on cuz103567d

. /c08/apps/apps_st/appl/APPSADMS08_cuz103567d.env
cd /c08/apps/apps_st/appl
[applmgr@cuz103567d appl]$ chmod 777 APPSADMS08_cuz103567d.env
[applmgr@cuz103567d appl]$ . ./APPSADMS08_cuz103567d.env
[applmgr@cuz103567d appl]$ echo $TWO_TASK
ADMS08

cd /home/applmgr/ADMS08/CLONE
start_app_onapp_server.sh

On App server cuz103567d login as applmgr & startup  Mobile Server.
cd /home/applmgr
echo $TWO_TASK
5 ./MWA_START.sh

ps -ef|grep -i ${TWO_TASK} | grep applmgr | grep -v grep
ps -ef|grep mwa | grep -i c08


Login to Portal Using 

http://cuz103567d.oneabbott.com:8008/

username:-sysadmin
password:-$abot1835
newyear#123


Change the profile options of .Site. to ADMS08 (currently it would show as ADMS)
Change the home page (FWK_HOMEPAGE) name to ADMS08 
==========================================================================================================================
erorr related to /s_adovar_ldlib
Use below solution.
But before that pls shut down services from node.

[applmgr@uq00342d scripts]$ . /c08/apps/apps_st/appl/APPSADMS08_uq00342d.env

[applmgr@uq00342d scripts]$ echo $TWO_TASK
[applmgr@uq00342d scripts]$ cp /c08/inst/apps/ADMS08_uq00342d/appl/admin/ADMS08_uq00342d.xml /c08/inst/apps/ADMS08_uq00342d/appl/admin/ADMS08_uq00342d.xml_bkp2

[applmgr@uq00342d scripts]$ vi /c08/inst/apps/ADMS08_uq00342d/appl/admin/ADMS08_uq00342d.xml

seacrh for /s_adovar_ldlib


Add Below line 

<LD_LIBRARY_PATH oa_var="s_adovar_ldlib" osd="LINUX_X86-64" customized="yes">/c08/apps/tech_st/10.1.2/jdk/jre/lib/i386:/c08/apps/tech_st/10.1.2/jdk/jre/lib/i386/server:/c08/apps/tech_st/10.1.2/jdk/jre/lib/i386/native_threads:/c08/apps/apps_st/appl/cz/12.0.0/bin:/c08/apps/tech_st/10.1.2/appsutil/jdk/jre/lib/i386/motif21:/c08/apps/tech_st/10.1.2/jdk/jre/lib/i386/motif21:${LD_LIBRARY_PATH:=}</LD_LIBRARY_PATH>


Then CHanging above line please run below steps.

[applmgr@uq00342d admin]$ cd /c05/inst/apps/ADMS05_uq00342d/admin
[applmgr@uq00342d admin]$ cd /c08/inst/apps/ADMS08_uq00342d/admin
[applmgr@uq00342d admin]$ cd scripts
[applmgr@uq00342d scripts]$

[applmgr@uq00342d admin]$ cd scripts
[applmgr@uq00342d scripts]$ pwd
/c08/inst/apps/ADMS08_uq00342d/admin/scripts
[applmgr@uq00342d scripts]$ sh adautocfg.sh
Enter the APPS user password:

The log file for this session is located at: /c08/inst/apps/ADMS08_uq00342d/admin/log/06041343/adconfig.log

AutoConfig is configuring the Applications environment...

AutoConfig will consider the custom templates if present.
        Using CONFIG_HOME location     : /c08/inst/apps/ADMS08_uq00342d
        Classpath                   : /c08/apps/apps_st/comn/java/lib/appsborg2.zip:/c08/apps/apps_st/comn/java/classes

        Using Context file          : /c08/inst/apps/ADMS08_uq00342d/appl/admin/ADMS08_uq00342d.xml

Context Value Management will now update the Context file

        Updating Context file...COMPLETED

        Attempting upload of Context file and templates to database...COMPLETED

Configuring templates from all of the product tops...
        Configuring AD_TOP........COMPLETED
        Configuring FND_TOP.......COMPLETED
        Configuring ICX_TOP.......COMPLETED
        Configuring MSC_TOP.......COMPLETED
        Configuring IEO_TOP.......COMPLETED
        Configuring BIS_TOP.......COMPLETED
        Configuring AMS_TOP.......COMPLETED
        Configuring CCT_TOP.......COMPLETED
        Configuring WSH_TOP.......COMPLETED
        Configuring CLN_TOP.......COMPLETED
        Configuring OKE_TOP.......COMPLETED
        Configuring OKL_TOP.......COMPLETED
        Configuring OKS_TOP.......COMPLETED
        Configuring CSF_TOP.......COMPLETED
        Configuring IGS_TOP.......COMPLETED
        Configuring IBY_TOP.......COMPLETED
        Configuring JTF_TOP.......COMPLETED
        Configuring MWA_TOP.......COMPLETED
        Configuring CN_TOP........COMPLETED
        Configuring CSI_TOP.......COMPLETED
        Configuring WIP_TOP.......COMPLETED
        Configuring CSE_TOP.......COMPLETED
        Configuring EAM_TOP.......COMPLETED
        Configuring FTE_TOP.......COMPLETED
        Configuring ONT_TOP.......COMPLETED
        Configuring AR_TOP........COMPLETED
        Configuring AHL_TOP.......COMPLETED
        Configuring OZF_TOP.......COMPLETED
        Configuring IES_TOP.......COMPLETED
        Configuring CSD_TOP.......COMPLETED
        Configuring IGC_TOP.......COMPLETED

AutoConfig completed successfully.
[applmgr@uq00342d scripts]$ echo $TWO_TASK
ADMS08
[applmgr@uq00342d scripts]$

==========================================================================================================================

Shut Down the Application Server & Mobile Service.

On App server cuz103567d login as applmgr

. /c08/apps/apps_st/appl/APPSADMS08_cuz103567d.env
echo $TWO_TASK

cd /home/applmgr/ADMS08/CLONE
4 ./4_shut_app_onapp_server_for_ref.sh

On App server cuz103567d login as applmgr & shut down Mobile Server.
cd /home/applmgr
echo $TWO_TASK
5 ./MWA_STOP.sh

Check Status
echo "ps -ef|grep -i ${TWO_TASK} | grep applmgr | grep -v grep"
ps -ef|grep -i ${TWO_TASK} | grep applmgr | grep -v grep
ps -ef|grep mwa | grep -i c08

Note: Please COnfirm All process should be down for ADMS08 Instance.


On DB Server uq00342d Login as applmgr and shut down the application
. /c08/apps/apps_st/appl/APPSADMS08_uq00342d.env
echo $TWO_TASK

cd /home/applmgr/ADMS08
6 ./6_shut_app_ondb_server_for_ref.sh

ps -ef|grep -i c08 | grep applmgr | grep -v grep

NOTE: Please wait for some time, application process take some time for complete shut down.

Also shut down the database,
sqlplus / as sysdba

. /c08/db/tech_st/12.1.0/ADMS08_uq00342d.env
echo $ORACLE_SID

echo $ORACLE_HOME
echo $ORACLE_SID
sqlplus / as sysdba
select name from v$database;

shut immediate


======================================================================================================================

To start The Service on EBS Server.

Start Database ADMS08

. /c08/db/tech_st/12.1.0/ADMS08_uq00342d.env
echo $ORACLE_SID
sqlplus / as sysdba
startup
select name from v$database;
lsnrctl start ADMS08
ps -ef|grep tns;ps -ef|grep pmon



login as applmgr on Server uq00342d


cd /c08/apps/apps_st/appl
. /c08/apps/apps_st/appl/APPSADMS08_uq00342d.env
echo $TWO_TASK

cd /home/applmgr/ADMS08/
./start_app_ondb_server.sh
ps -ef|grep -i c08 | grep applmgr | grep -v grep



Login as applmgr on cuz103567d

. /c08/apps/apps_st/appl/APPSADMS08_cuz103567d.env
cd /c08/apps/apps_st/appl
[applmgr@cuz103567d appl]$ chmod 777 APPSADMS08_cuz103567d.env
[applmgr@cuz103567d appl]$ . ./APPSADMS08_cuz103567d.env
[applmgr@cuz103567d appl]$ echo $TWO_TASK
ADMS08

cd /home/applmgr/ADMS08/CLONE
start_app_onapp_server.sh


On App server cuz103567d login as applmgr & startup  Mobile Server.
cd /home/applmgr
echo $TWO_TASK
5 ./MWA_START.sh

ps -ef|grep -i ${TWO_TASK} | grep applmgr | grep -v grep
ps -ef|grep mwa | grep -i c08

====================================================================================================================================
 ps -ef|grep -i c08 |grep -v grep | awk '{print $2}'|xargs kill -9

rm -fr /IBMORABKPNONPRD/ADMS08
mkdir -p /IBMORABKPNONPRD/ADMS08

ls -ld /IBMORABKPNONPRD/ADMS08

bash-4.2$ ls -ld /IBMORABKPNONPRD/ADMS08
drwxr-xr-x 2 oracle oinstall 277387 Dec  1 21:23 /IBMORABKPNONPRD/ADMS08
bash-4.2$

