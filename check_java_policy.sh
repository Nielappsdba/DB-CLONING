sqlplus -s / as sysdba <<EOF
set linesize 191
col grantee format a10
col type_schema format a5
col type_name format a30
col name format a20
col action format a20
col enabled format a10

SELECT * FROM dba_java_policy
where GRANTEE='LOFTWARE';
EOF
