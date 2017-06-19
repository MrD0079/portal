/* Formatted on 25/05/2016 12:36:23 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT tn.net_kod, tn.net, tn.h_net
    FROM user_list u, tp_nets tn, a14mega m
   WHERE     u.tab_num = m.tab_num
         AND u.dpt_id = m.dpt_id
         AND u.dpt_id = :dpt_id
     and u.is_spd=1
    AND (   u.tn IN (SELECT slave
                            FROM full
                           WHERE master = (DECODE ( :tn, -1, master, :tn)))
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND tn.tp_kod = m.tp_kod
         AND (:eta_list is null OR :eta_list = m.h_eta)
ORDER BY tn.net