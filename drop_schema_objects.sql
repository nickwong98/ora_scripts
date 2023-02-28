-- DROP ALL SCHEMA OBJECTS (update schema owner below)
SET SERVEROUTPUT ON SIZE 1000000
BEGIN
  FOR cur_rec IN (SELECT owner,
                         object_name,
                         object_type
                  FROM   dba_objects
                  WHERE  owner='<schema_name>' -- schema name
                  ORDER BY 1,2,3)
  LOOP
    BEGIN
      IF cur_rec.object_type = 'SEQUENCE' THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE "' || cur_rec.owner || 
            '"."' || cur_rec.object_name || '"';
      ELSIF cur_rec.object_type = 'PROCEDURE' THEN
        EXECUTE IMMEDIATE 'DROP PROCEDURE "' || cur_rec.owner || 
            '"."' || cur_rec.object_name || '"';
      ELSIF cur_rec.object_type = 'PACKAGE' THEN
        EXECUTE IMMEDIATE 'DROP PACKAGE "' || cur_rec.owner || 
            '"."' || cur_rec.object_name || '"';
      ELSIF cur_rec.object_type = 'FUNCTION' THEN
        EXECUTE IMMEDIATE 'DROP FUNCTION "' || cur_rec.owner || 
            '"."' || cur_rec.object_name || '"';
      ELSIF cur_rec.object_type = 'VIEW' THEN
        EXECUTE IMMEDIATE 'DROP VIEW "' || cur_rec.owner || 
            '"."' || cur_rec.object_name || '"';
      ELSIF cur_rec.object_type = 'TABLE' THEN
        EXECUTE IMMEDIATE 'DROP TABLE "' || cur_rec.owner || 
            '"."' || cur_rec.object_name || '" PURGE';
      ELSIF cur_rec.object_type = 'TYPE' THEN
        EXECUTE IMMEDIATE 'DROP TYPE "' || cur_rec.owner || 
            '"."' || cur_rec.object_name || '"';
      ELSIF cur_rec.object_type = 'SYNONYM' THEN
        EXECUTE IMMEDIATE 'DROP SYNONYM "' || cur_rec.owner || 
            '"."' || cur_rec.object_name || '"';
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('ERROR DROPPING: ' || cur_rec.object_type || ' : ' || cur_rec.owner || 
                             '.' || cur_rec.object_name);
    END;
  END LOOP;
END;
/

-- check remaining objects
-- select object_type,count(1) from dba_objects where owner='SITSx' group by object_type;

-- purge tables in recyclebin
-- select 'PURGE TABLE ' || OWNER || '."' || OBJECT_NAME || '";' from dba_recyclebin where owner='SITS' AND type='TABLE';
