/* Formatted on 11.01.2013 13:04:56 (QP5 v5.163.1008.3004) */
  SELECT cpn.id_net,
         cpn.net_name,
         cpn.y,
         d.sales
    FROM (SELECT DISTINCT c.y, n.id_net, n.net_name
            FROM calendar c, nets n
           WHERE     y BETWEEN :y - 2 AND :y
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
                 AND DECODE (:tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk) cpn,
         (SELECT p.id_net, p.YEAR, p.sales
            FROM nets_plan_year p
           WHERE p.YEAR BETWEEN :y - 2 AND :y AND plan_type = 1) d
   WHERE cpn.y = d.YEAR(+) AND cpn.id_net = d.id_net(+)
ORDER BY cpn.net_name, cpn.y, d.sales DESC