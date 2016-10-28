/* Formatted on 23.08.2013 11:55:51 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT rh.num
    FROM user_list u, routes_head rh
   WHERE     u.pos_id = 69
         AND u.dpt_id = :dpt_id
         AND ADD_MONTHS (TRUNC (NVL (u.datauvol, SYSDATE), 'mm'), +1) >=
                TRUNC (SYSDATE, 'mm')
         AND u.tn = rh.tn
         AND (   u.tn IN (SELECT slave
                               FROM full
                              WHERE master = :tn)
              OR (SELECT is_ma
                    FROM user_list
                   WHERE tn = :tn) = 1 OR (SELECT is_admin
                                        FROM user_list
                                       WHERE tn = :tn) = 1)
         AND rh.num IS NOT NULL
ORDER BY rh.num