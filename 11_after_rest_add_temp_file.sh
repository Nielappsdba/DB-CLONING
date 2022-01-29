sqlplus -s / as sysdba <<EOF
select name from v$database;
select name from v$tempfiles; 	
alter tablespace temp add tempfile '/c02/oradata/ADMS02/tmp/temp01.dbf' size 1024m autoextend on next 102400 maxsize 10G;
EOF

echo "Temp Tablespace Added Successfully...."

