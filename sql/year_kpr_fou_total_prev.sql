/* Formatted on 27/11/2015 6:05:17 PM (QP5 v5.252.13127.32867) */
  SELECT SUM (total) total
    FROM (  SELECT sc.my,
                   sc.mt,
                   sc.plan_type,
                   sc.plan_name,
                   SUM (NVL (fou.total, 0)) total
              FROM (SELECT s.PARENT,
                           s.ID,
                           s.cost_item,
                           c.*,
                           p.ID plan_type,
                           p.NAME plan_name
                      FROM statya s,
                           (SELECT ID, NAME
                              FROM nets_plan_type
                             WHERE ID IN (4)) p,
                           (SELECT DISTINCT y, my, mt
                              FROM calendar
                             WHERE y = :y AND my < EXTRACT (MONTH FROM SYSDATE)) c
                     WHERE     s.PARENT <> 0
                           /*AND s.PARENT IN ( :GROUPS)*/
                           AND CASE
                                  WHEN s.parent NOT IN (42, 96882041) THEN 1
                                  WHEN s.parent = 42 THEN 3
                                  WHEN s.parent = 96882041 THEN 2
                               END IN ( :mgroups)
                           AND DECODE ( :statya_list, 0, s.ID, :statya_list) =
                                  s.ID) sc,
                   (  SELECT SUM (total) total,
                             m.statya,
                             m.YEAR,
                             m.plan_type,
                             m.MONTH
                        FROM nets_plan_month m, nets n
                       WHERE     m.id_net = n.id_net
                             AND :tn IN (DECODE (
                                            (SELECT pos_id
                                               FROM spdtree
                                              WHERE svideninn = :tn),
                                            24, n.tn_mkk,
                                            34, n.tn_rmkk,
                                            63, :tn,
                                            65, :tn,
                                            67, :tn,
                                            (SELECT pos_id
                                               FROM user_list
                                              WHERE tn = :tn AND is_super = 1), :tn,
                                            (SELECT pos_id
                                               FROM user_list
                                              WHERE tn = :tn AND is_admin = 1), :tn))
                             AND DECODE ( :net, 0, n.id_net, :net) = n.id_net
                             AND (   n.id_net IN (SELECT kk_flt_nets_detail.id_net
                                                    FROM kk_flt_nets,
                                                         kk_flt_nets_detail
                                                   WHERE     kk_flt_nets.id =
                                                                :flt_id
                                                         AND kk_flt_nets.id =
                                                                kk_flt_nets_detail.id_flt)
                                  OR :flt_id = 0)
                             AND DECODE ( :tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) =
                                    n.tn_rmkk
                             AND DECODE ( :tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
                             AND m.YEAR = :y
                             AND DECODE ( :payment_type,
                                         0, m.payment_type,
                                         :payment_type) = m.payment_type
                    GROUP BY m.statya,
                             m.YEAR,
                             m.plan_type,
                             m.MONTH) fou
             WHERE     sc.ID = fou.statya(+)
                   AND sc.y = fou.YEAR(+)
                   AND sc.plan_type = fou.plan_type(+)
                   AND sc.my = fou.MONTH(+)
          GROUP BY sc.y,
                   sc.my,
                   sc.mt,
                   sc.plan_type,
                   sc.plan_name)
GROUP BY plan_type, plan_name
ORDER BY plan_type