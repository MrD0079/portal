/* Formatted on 11.01.2013 13:17:02 (QP5 v5.163.1008.3004) */
  SELECT n.id_net, n.net_name, d.id
    FROM nets n, kk_flt_nets_detail d
   WHERE     :tn IN (DECODE ( (SELECT pos_id
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
         AND n.id_net = d.id_net(+)
         AND d.id_flt(+) = :id_flt
ORDER BY net_name