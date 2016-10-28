/* Formatted on 17.07.2013 16:41:50 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT rh.fio_otv
    FROM user_list u, routes_head rh
   WHERE     u.pos_id = 69
         AND u.dpt_id = :dpt_id
         AND ADD_MONTHS (TRUNC (NVL (u.datauvol, SYSDATE), 'mm'), +1) >=
                TRUNC (SYSDATE, 'mm')
         AND u.tn = rh.tn
--         AND TRUNC (rh.data, 'mm') = TRUNC (TO_DATE (:ed, 'dd/mm/yyyy'), 'mm')
         AND (   u.tn IN (SELECT slave
                               FROM full
                              WHERE master = :tn)
              OR (SELECT is_ma
                    FROM user_list
                   WHERE tn = :tn) = 1 OR (SELECT is_admin
                                        FROM user_list
                                       WHERE tn = :tn) = 1)
         AND rh.fio_otv IS NOT NULL
ORDER BY rh.fio_otv