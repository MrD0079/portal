/* Formatted on 29.05.2017 10:17:16 (QP5 v5.252.13127.32867) */
  SELECT tn, fio
    FROM user_list
   WHERE     pos_id = 9214311
         AND dpt_id = :dpt_id
         AND ADD_MONTHS (TRUNC (NVL (datauvol, SYSDATE), 'mm'), +1) >=
                TRUNC (SYSDATE, 'mm')
         AND (   tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn)
              OR (SELECT is_admin
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT is_ma
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT is_kk
                    FROM user_list
                   WHERE tn = :tn) = 1)
ORDER BY fio