/* Formatted on 17/06/2015 12:58:02 (QP5 v5.227.12220.39724) */
  SELECT sc.y,
         sc.my,
         sc.mt,
         NVL (SUM (PLAN.cnt), 0) cnt,
         NVL (SUM (PLAN.total), 0) total
    FROM (SELECT s.PARENT,
                 s.ID,
                 s.cost_item,
                 c.*,
                 p.ID plan_type
            FROM statya s,
                 (SELECT :plan_type ID FROM DUAL) p,
                 (SELECT DISTINCT y, my, mt
                    FROM calendar
                   WHERE     y BETWEEN :y - 1 AND :y
                         AND DECODE (:MONTH, 0, my, :MONTH) = my) c
           WHERE     s.PARENT <> 0
                 AND s.PARENT IN (:GROUPS)
                 AND DECODE (:statya_list, 0, s.ID, :statya_list) = s.ID) sc,
         (  SELECT SUM (cnt) cnt,
                   SUM (total) total,
                   m.statya,
                   m.YEAR,
                   m.plan_type,
                   m.MONTH
              FROM nets_plan_month m, nets n
             WHERE     m.id_net = n.id_net
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
                                         WHERE tn = :tn AND is_super = 1), :tn,
                                       (SELECT pos_id
                                          FROM user_list
                                         WHERE tn = :tn AND is_admin = 1), :tn))
                   AND DECODE (:net, 0, n.id_net, :net) = n.id_net
                   AND DECODE (:tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
                   AND DECODE (:tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
                   AND (   n.id_net IN
                              (SELECT kk_flt_nets_detail.id_net
                                 FROM kk_flt_nets, kk_flt_nets_detail
                                WHERE     kk_flt_nets.id = :flt_id
                                      AND kk_flt_nets.id =
                                             kk_flt_nets_detail.id_flt)
                        OR :flt_id = 0)
                   AND m.YEAR BETWEEN :y - 1 AND :y
                   AND DECODE (:MONTH, 0, m.MONTH, :MONTH) = m.MONTH
                   AND DECODE (:payment_type, 0, m.payment_type, :payment_type) =
                          m.payment_type
          GROUP BY m.statya,
                   m.YEAR,
                   m.plan_type,
                   m.MONTH) PLAN
   WHERE     sc.ID = PLAN.statya(+)
         AND sc.y = PLAN.YEAR(+)
         AND sc.plan_type = PLAN.plan_type(+)
         AND sc.my = PLAN.MONTH(+)
GROUP BY sc.y, sc.my, sc.mt
ORDER BY sc.y, sc.my, sc.mt