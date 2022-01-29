set heading off
set newpage 0
set pages 0
set verify off
set feedback off

spool mkdir.sh
select '#!/bin/ksh'
from dual
/
select 'mkdir -p ' || substr(name,1,instr(name,'/',-1) - 1) from v$datafile
union
select 'mkdir -p ' || substr(name,1,instr(name,'/',-1) - 1) from v$tempfile
union
select 'mkdir -p ' || substr(name,1,instr(name,'/',-1) - 1) from v$controlfile
union
select 'mkdir -p ' || substr(member,1,instr(member,'/',-1) - 1) from v$logfile
/
spool off
REM
REM  Change to make executable
REM
host chmod 755 mkdir.sh
exit
====================================
