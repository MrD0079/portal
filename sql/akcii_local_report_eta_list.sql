/* Formatted on 09/04/2015 17:24:15 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT r.h_eta, r.eta
    FROM routes r, user_list u
   WHERE     r.tab_number = u.tab_num
         AND r.dpt_id = u.dpt_id
         AND u.dpt_id = :dpt_id
         AND u.datauvol IS NULL
         AND (   u.tn IN (SELECT slave
                            FROM full
                           WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
ORDER BY r.eta