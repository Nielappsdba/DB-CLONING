Enter value for 1: LOFTWARE

   CREATE USER "LOFTWARE" IDENTIFIED BY VALUES 'S:E4E1E073C89F0E37A4132B89BCEBD523883E4B1ACC6C086AE2378DF4E8A1;H:EBF5D09BE04C0A5FBD25F7EE1F8F6AEF;T:8F8A0A0BBF00173450906DD6DB612CBC3D0604A37778A01611A5E2718CA2294D17D8AC01DEE0C6A3065C2412902E13FC7B6F9379CABDC6AEB7BE159982E0B7BC93E52FE471FAEDAE29D227AB495B4940;23D62AC65136B500'
      DEFAULT TABLESPACE "XXLOWACO"
      TEMPORARY TABLESPACE "TEMP";


  DECLARE
  TEMP_COUNT NUMBER;
  SQLSTR VARCHAR2(200);
BEGIN
  SQLSTR := 'ALTER USER "LOFTWARE" QUOTA UNLIMITED ON "XXLOWACO"';
  EXECUTE IMMEDIATE SQLSTR;
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE = -30041 THEN
      SQLSTR := 'SELECT COUNT(*) FROM USER_TABLESPACES
              WHERE TABLESPACE_NAME = ''XXLOWACO'' AND CONTENTS = ''TEMPORARY''';
      EXECUTE IMMEDIATE SQLSTR INTO TEMP_COUNT;
      IF TEMP_COUNT = 1 THEN RETURN;
      ELSE RAISE;
      END IF;
    ELSE
      RAISE;
    END IF;
END;
/


   GRANT "CONNECT" TO "LOFTWARE";
   GRANT "RESOURCE" TO "LOFTWARE";
   GRANT "DBA" TO "LOFTWARE";


  GRANT UNLIMITED TABLESPACE TO "LOFTWARE";


   ALTER USER "LOFTWARE" DEFAULT ROLE ALL;

