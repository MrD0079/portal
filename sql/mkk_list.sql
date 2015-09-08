/* Formatted on 09/12/2014 21:45:35 (QP5 v5.227.12220.39724) */
  SELECT tn, fio
    FROM user_list
   WHERE     is_mkk_new=1
         AND dpt_id = :dpt_id
         AND ADD_MONTHS (TRUNC (NVL (datauvol, SYSDATE), 'mm'), +1) >=
                TRUNC (SYSDATE, 'mm')
         AND (   tn IN (SELECT emp_tn
                          FROM who_full
                         WHERE exp_tn = :tn)
              OR (SELECT is_ma
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT is_kk
                    FROM user_list
                   WHERE tn = :tn) = 1)
ORDER BY fio