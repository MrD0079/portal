/* Formatted on 19/11/2015 4:29:04 PM (QP5 v5.252.13127.32867) */
  SELECT r1.ts,
         r1.eta,
         r1.tp_name,
         r1.address,
         p.plan
    FROM (SELECT DISTINCT r.ts,
                          r.eta,
                          r.h_eta,
                          r.tp_kod,
                          r.tp_name,
                          r.address,
                          r.tp_place,
                          r.tp_type,
                          r.tab_number,
                          r.dpt_id
            FROM routes r) r1,
         user_list u,
         tpplan p
   WHERE     p.dt(+) = TO_DATE ( :dt, 'dd.mm.yyyy')
         AND p.tp_kod(+) = r1.tp_kod
         AND r1.tab_number = u.tab_num
         AND r1.dpt_id = u.dpt_id
         AND u.dpt_id = :dpt_id
         AND (   :exp_list_without_ts = 0
                      OR u.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_without_ts))
         AND (   :exp_list_only_ts = 0
                      OR u.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_only_ts))
         AND u.tn IN (SELECT slave
                        FROM full
                       WHERE master = DECODE ( :tn, -1, master, :tn))
         /*AND r1.tp_kod = 1000424537*/
         AND (:eta_list is null OR :eta_list = r1.h_eta)
ORDER BY r1.ts,
         r1.eta,
         r1.tp_name,
         r1.address