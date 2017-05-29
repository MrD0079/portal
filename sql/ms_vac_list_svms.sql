/* Formatted on 29.05.2017 10:50:29 (QP5 v5.252.13127.32867) */
  SELECT u.tn, u.fio
    FROM user_list u, parents p, user_list UP
   WHERE     u.tn = p.tn
         AND p.parent = UP.tn(+)
         AND UP.pos_id(+) = 9214311
         AND u.pos_id = 69
         AND u.dpt_id = :dpt_id
         AND ADD_MONTHS (TRUNC (NVL (u.datauvol, SYSDATE), 'mm'), +1) >=
                TRUNC (SYSDATE, 'mm')
         AND (   u.tn IN (SELECT slave
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
         AND ( :rm_tn = 0 OR :rm_tn = UP.tn)
ORDER BY u.fio