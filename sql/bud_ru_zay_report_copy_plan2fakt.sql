/* Formatted on 15/02/2016 12:39:48 (QP5 v5.252.13127.32867) */
BEGIN
   FOR a IN (  SELECT column_name
                 FROM USER_TAB_COLUMNS
                WHERE table_name = 'BUD_RU_ZAY_FF' AND column_name LIKE 'VAL_%'
             ORDER BY column_name)
   LOOP
      EXECUTE IMMEDIATE
            'update BUD_RU_ZAY_FF set REP_'
         || a.column_name
         || '='
         || a.column_name
         || ' where z_id='
         || :z_id;

      COMMIT;
   END LOOP;
END;