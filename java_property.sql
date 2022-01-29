exec dbms_java.grant_permission('LOFTWARE', 'SYS:java.util.PropertyPermission', 'javax.xml.parsers.DocumentBuilderFactory', 'read,write,execute');
commit;
