/* Formatted on 30/06/2015 11:06:31 (QP5 v5.227.12220.39724) */
BEGIN
   IF TO_NUMBER (TO_CHAR (SYSDATE, 'dd')) >= 16
   THEN
      /*add_job ( (ADD_MONTHS (TRUNC (SYSDATE, 'mm'), 1) + 15 - SYSDATE) * 24,
               'begin pr_replace_ts (:tn_from, :tn_to, 1); end;');*/
      pr_replace_ts (:tn_from, :tn_to, 1);
   ELSE
      add_job ( (TRUNC (SYSDATE, 'mm') + 15 - SYSDATE) * 24,
               'begin pr_replace_ts (:tn_from, :tn_to, 1); end;');
   END IF;
END;