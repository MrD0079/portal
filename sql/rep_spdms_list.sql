/* Formatted on 10.06.2015 16:24:49 (QP5 v5.227.12220.39724) */
  SELECT id,
         fio,
         tn,
         ter_ms,
         TO_CHAR (last_month, 'dd.mm.yyyy') last_month,
         contract_num,
         TO_CHAR (contract_end, 'dd.mm.yyyy') contract_end
    FROM rep_spdms_list
   WHERE    :valid = 1
         OR (    :valid = 2
             AND (last_month IS NULL OR last_month >= TRUNC (SYSDATE, 'mm')))
         OR (:valid = 3 AND last_month < TRUNC (SYSDATE, 'mm'))
ORDER BY fio