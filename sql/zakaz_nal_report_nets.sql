/* Formatted on 02/11/2015 17:11:53 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT n.id_net, n.net_name
    FROM nets n, nets_plan_month m
   WHERE     m.mkk_ter IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
         AND n.id_net = m.id_net
         AND m.plan_type = 3
ORDER BY n.net_name