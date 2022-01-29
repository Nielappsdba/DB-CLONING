sqlplus / as sysdba <<eof
set lines 280
col USERNAME for a8
col PROCESS for a5
col SPID for a6
col MODULE for a20
col ACTION for a10
col PROGRAM for a16
col MACHINE for a24
col SQL_TEXT for a60

select vse.username, vse.sid, vse.serial#, vse.process, vse.module, vse.action,                                                                   vse.program, vp.pid, vp.spid, vse.MACHINE, vsq.sql_text
from v\$session vse, v\$sqltext vsq, v\$process vp
where vse.sql_address=vsq.address
and vse.sql_hash_value=vsq.hash_value
and vp.addr = vse.paddr
and vse.module like '%JDBC%'
order by vse.sid , vse.serial# , vsq.piece;
eof
