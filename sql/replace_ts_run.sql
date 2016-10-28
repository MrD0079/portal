/* Formatted on 02/11/2015 18:42:13 (QP5 v5.252.13127.32867) */
DECLARE
   from_tabnum   INTEGER;
   to_tabnum     INTEGER;
   fio_from      VARCHAR2 (200);
   fio_to        VARCHAR2 (200);
BEGIN
   pr_replace_ts ( :tn_from, :tn_to, 1);
   /*
   IF TO_NUMBER (TO_CHAR (SYSDATE, 'dd')) >= 16
   THEN
      pr_replace_ts ( :tn_from, :tn_to, 1);
   ELSE
      add_job ( (TRUNC (SYSDATE, 'mm') + 15 - SYSDATE) * 24,
               'begin pr_replace_ts (:tn_from, :tn_to, 1); end;');

      SELECT tab_num, fio
        INTO from_tabnum, fio_from
        FROM user_list
       WHERE tn = :tn_from;

      SELECT tab_num, fio
        INTO to_tabnum, fio_to
        FROM user_list
       WHERE tn = :tn_to;

      INSERT INTO full_log (text, prg)
              VALUES (
                           'замена ТС '
                        || fio_from
                        || ' '
                        || :tn_from
                        || ' на '
                        || fio_to
                        || ' '
                        || :tn_to
                        || ' будет произведена '
                        || TO_CHAR ( (TRUNC (SYSDATE, 'mm') + 15),
                                    'dd.mm.yyyy'),
                        'replace_ts');

      COMMIT;
   END IF;
   */
END;