/* Formatted on 27/05/2016 15:42:42 (QP5 v5.252.13127.32867) */
  SELECT tn.net_kod,
         tn.net,
         NVL (tn.isrc, 0) isrc,
         SUM (m.summa) summa,
         COUNT (*) / COUNT (DISTINCT m.dt) c
    FROM user_list u, tp_nets tn, a14mega m
   WHERE     u.tab_num = m.tab_num
         AND u.dpt_id = m.dpt_id
         AND u.dpt_id = :dpt_id
     and u.is_spd=1
    AND (   :exp_list_without_ts = 0
              OR u.tn IN (SELECT slave
                            FROM full
                           WHERE master = :exp_list_without_ts))
         AND (   :exp_list_only_ts = 0
              OR u.tn IN (SELECT slave
                            FROM full
                           WHERE master = :exp_list_only_ts))
         AND (   u.tn IN (SELECT slave
                            FROM full
                           WHERE master = (DECODE ( :tn, -1, master, :tn)))
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR :affiliation = 'all')
         AND tn.tp_kod = m.tp_kod
         AND m.dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                      AND TO_DATE ( :ed, 'dd.mm.yyyy')
         AND (:eta_list is null OR :eta_list = m.h_eta)
         AND (   ( :salesbychainsisrc = 'all')
              OR (NVL (tn.isrc, 0) = 1 AND :salesbychainsisrc = 'isrc')
              OR (NVL (tn.isrc, 0) = 0 AND :salesbychainsisrc = 'bytp'))
         AND DECODE ( :chains, 0, tn.net_kod, :chains) = tn.net_kod
GROUP BY tn.net_kod, tn.net, tn.isrc
ORDER BY DECODE ( :salesbychainssort,  'name', 0,  'sales', SUM (m.summa)) DESC NULLS LAST,
         tn.net