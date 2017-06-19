/* Formatted on 06/04/2016 14:45:57 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT SUBSTR (day_pos, 1, 1) col
    FROM (SELECT DISTINCT r.day_pos
            FROM routes r, user_list u
           WHERE     r.olstatus = 1
                 AND r.dpt_id = u.dpt_id
                 AND r.tab_number = u.tab_num
                 AND u.dpt_id = :dpt_id
            and u.is_spd=1
     AND u.datauvol IS NULL
                 AND (   u.tn IN (SELECT slave
                                    FROM full
                                   WHERE master = :tn)
                      OR (SELECT NVL (is_admin, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1
                      OR (SELECT NVL (is_super, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1
                      OR (SELECT NVL (is_kpr, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1
                      OR :tn = -1)
                 AND ( :tn <> -1 OR ( :tn = -1 AND :routes_eta_list = r.h_eta)))
         z
ORDER BY col