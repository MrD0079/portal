/* Formatted on 11.01.2013 13:30:45 (QP5 v5.163.1008.3004) */
  SELECT n.*,
         cpp.*,
         fn_getname ( n.tn_rmkk) rmkk_name,
         fn_getname ( n.tn_mkk) mkk_name
    FROM nets n, coveringpointspos cpp
   WHERE     N.SW_KOD = cpp.id_net
         AND n.tn_mkk IN (SELECT emp_tn
                            FROM who_full
                           WHERE exp_tn = :tn)
         AND DECODE (:tz_eta_list, '', fio_eta, :tz_eta_list) = fio_eta
         AND TRUNC (cpp.DATA, 'mm') = TO_DATE (:sd, 'dd.mm.yyyy')
         AND :tn IN (DECODE ( (SELECT pos_id
                                  FROM spdtree
                                 WHERE svideninn = :tn),
                              24, n.tn_mkk,
                              34, n.tn_rmkk,
                              63, :tn,
                              65, :tn,
                              67, :tn,
                              (SELECT pos_id
                                 FROM user_list
                                WHERE tn = :tn AND is_super = 1), :tn))
         AND DECODE (:net, 0, n.id_net, :net) = n.id_net
         AND DECODE (:tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
         AND DECODE (:tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
         AND (n.id_net IN (SELECT kk_flt_nets_detail.id_net
                             FROM kk_flt_nets, kk_flt_nets_detail
                            WHERE kk_flt_nets.id = :flt_id AND kk_flt_nets.id = kk_flt_nets_detail.id_flt)
              OR :flt_id = 0)
ORDER BY net_name,
         rmkk_name,
         mkk_name,
         ur_tz_name,
         tz_oblast,
         fio_eta