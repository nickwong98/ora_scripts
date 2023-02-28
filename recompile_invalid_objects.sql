SET SERVEROUTPUT ON SIZE 1000000
BEGIN
  FOR cur_rec IN (SELECT owner,
                         object_name,
                         object_type
                  FROM   dba_objects
                  WHERE  object_type IN ('PACKAGE','PACKAGE BODY','SYNONYM','PROCEDURE','VIEW','FUNCTION','MATERIALIZED VIEW','TRIGGER')
                  AND    status != 'VALID'
                  ORDER BY 1,3,2)
  LOOP
    BEGIN
      IF cur_rec.object_type = 'PACKAGE BODY' THEN
        EXECUTE IMMEDIATE 'ALTER PACKAGE "' || cur_rec.owner || 
            '"."' || cur_rec.object_name || '" COMPILE BODY';
      ELSE
        EXECUTE IMMEDIATE 'ALTER ' || cur_rec.object_type || 
            ' "' || cur_rec.owner || '"."' || cur_rec.object_name || '" COMPILE';
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('INVALID ' || cur_rec.object_type || ' : ' || cur_rec.owner || 
                             '.' || cur_rec.object_name);
    END;
  END LOOP;
END;
/


--select owner,object_type,object_name from dba_objects where status<>'VALID' ORDER BY 1,2,3;
