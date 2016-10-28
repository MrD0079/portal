/* Formatted on 23/05/2016 11:59:20 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT r.h_eta, r.eta
    FROM a14mega r, user_list u
   WHERE     r.tab_num = u.tab_num
         AND u.dpt_id = r.dpt_id
         AND (   u.tn IN (SELECT slave
                            FROM full
                           WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_traid_kk, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND r.dpt_id = :dpt_id
         AND r.dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                      AND TO_DATE ( :ed, 'dd.mm.yyyy')
ORDER BY eta