/* Formatted on 07/04/2015 12:03:34 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT r.h_eta h_eta, r.eta eta
    FROM a14mega r, user_list u, departments d
   WHERE     r.tab_num = u.tab_num
         AND d.manufak = r.country
         AND d.dpt_id = :dpt_id
         AND u.dpt_id = :dpt_id
         AND (   u.tn IN (SELECT slave
                            FROM full
                           WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_traid_kk, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND d.manufak = r.country
         AND d.dpt_id = :dpt_id
ORDER BY eta