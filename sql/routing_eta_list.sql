/* Formatted on 06/04/2016 14:46:22 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT r.h_eta, r.eta
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
ORDER BY r.eta