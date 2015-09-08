/* Formatted on 06.03.2012 8:19:37 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT n.id_net, n.net_name
    FROM nets n, nets_plan_month m
   WHERE     m.mkk_ter IN (SELECT emp_tn
                             FROM who_full
                            WHERE exp_tn = :tn)
         AND n.id_net = m.id_net
         AND m.plan_type = 3
ORDER BY n.net_name