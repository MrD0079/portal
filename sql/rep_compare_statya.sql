/* Formatted on 17/06/2015 13:06:10 (QP5 v5.227.12220.39724) */
SELECT ROWNUM,
       DECODE (ROUND (ROWNUM / 10 - 0.5) * 10 + 1 - ROWNUM, 0, 1, 0)
          draw_head,
       DECODE (ROUND (ROWNUM / 2) * 2, ROWNUM, 1, 0) color,
       z.*
  FROM (  SELECT sc.ID,
                 sc.cost_item,
                 sc.y,
                 sc.plan_type,
                 NVL (plan.cnt, 0) cnt,
                 NVL (plan.total, 0) total
            FROM (SELECT s.PARENT,
                         s.ID,
                         s.cost_item,
                         c.*,
                         p.ID plan_type
                    FROM statya s,
                         (SELECT *
                            FROM nets_plan_type
                           WHERE id IN (1, 2, 3)) p,
                         (SELECT DISTINCT y
                            FROM calendar
                           WHERE y BETWEEN :y - 2 AND :y) c
                   WHERE     s.PARENT <> 0
                         AND s.PARENT IN (:GROUPS)
                         AND DECODE (:statya_list, 0, s.ID, :statya_list) =
                                s.ID) sc,
                 (  SELECT SUM (cnt) cnt,
                           SUM (total) total,
                           m.statya,
                           m.YEAR,
                           m.plan_type
                      FROM nets_plan_month m, nets n
                     WHERE     m.id_net = n.id_net
                           AND :tn IN
                                  (DECODE (
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
                                        WHERE tn = :tn AND is_super = 1), :tn))
                           AND DECODE (:net, 0, n.id_net, :net) = n.id_net
                           AND DECODE (:tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) =
                                  n.tn_rmkk
                           AND DECODE (:tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
                           AND (   n.id_net IN
                                      (SELECT kk_flt_nets_detail.id_net
                                         FROM kk_flt_nets, kk_flt_nets_detail
                                        WHERE     kk_flt_nets.id = :flt_id
                                              AND kk_flt_nets.id =
                                                     kk_flt_nets_detail.id_flt)
                                OR :flt_id = 0)
                           AND m.YEAR BETWEEN :y - 2 AND :y
                           AND DECODE (:MONTH, 0, m.MONTH, :MONTH) = m.MONTH
                           AND DECODE (:payment_type,
                                       0, m.payment_type,
                                       :payment_type) = m.payment_type
                  GROUP BY m.statya, m.YEAR, m.plan_type) plan
           WHERE     sc.ID = plan.statya(+)
                 AND sc.y = plan.YEAR(+)
                 AND sc.plan_type = plan.plan_type(+)
        ORDER BY sc.PARENT,
                 sc.cost_item,
                 sc.y,
                 sc.plan_type) z