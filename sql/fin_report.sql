/* Formatted on 23/11/2015 5:27:31 PM (QP5 v5.252.13127.32867) */
SELECT ROWNUM,
       DECODE (ROUND (ROWNUM / 10 - 0.5) * 10 + 1 - ROWNUM, 0, 1, 0)
          draw_head,
       z.*
  FROM (  SELECT n.tn_rmkk,
                 n.tn_mkk,
                 fn_getname (n.tn_rmkk) rmkk,
                 fn_getname (n.tn_mkk) mkk,
                 n.net_name,
                 DECODE (y.no_budget, 1, 'да', '') no_budget,
                 NVL (y.sales_prev, 0) prev_year_fakt,
                 NVL (y.sales, 0) year_plan,
                 DECODE (NVL (y.sales_prev, 0),
                         0, 0,
                         (y.sales / y.sales_prev - 1) * 100)
                    perc_rost,
                 (SELECT NVL (SUM (total), 0)
                    FROM nets_plan_month m
                   WHERE     m.YEAR = :y - 1
                         AND m.plan_type = 4
                         AND m.id_net = n.id_net)
                    prev_year_fou,
                 (SELECT NVL (SUM (total), 0)
                    FROM nets_plan_month m
                   WHERE     m.YEAR = :y
                         AND m.plan_type = :plan_type
                         AND m.id_net = n.id_net)
                    budget,
                 (SELECT NVL (SUM (total), 0)
                    FROM nets_plan_month m
                   WHERE     m.YEAR = :y - 1
                         AND m.plan_type = :plan_type
                         AND m.id_net = n.id_net)
                    prev_year_budget,
                 DECODE (
                    NVL (
                       (SELECT SUM (total)
                          FROM nets_plan_month m
                         WHERE     m.YEAR = :y - 1
                               AND m.plan_type = :plan_type
                               AND m.id_net = n.id_net),
                       0),
                    0, 0,
                        (SELECT SUM (total)
                           FROM nets_plan_month m
                          WHERE     m.YEAR = :y
                                AND m.plan_type = :plan_type
                                AND m.id_net = n.id_net)
                      / (SELECT SUM (total)
                           FROM nets_plan_month m
                          WHERE     m.YEAR = :y - 1
                                AND m.plan_type = :plan_type
                                AND m.id_net = n.id_net)
                      * 100
                    - 100)
                    budget_rost,
                 DECODE (
                    NVL (y.sales, 0),
                    0, 0,
                      (SELECT NVL (SUM (total), 0)
                         FROM nets_plan_month m
                        WHERE     m.YEAR = :y
                              AND m.plan_type = :plan_type
                              AND m.id_net = n.id_net)
                    / y.sales
                    * 100)
                    perc_zatr,
                 DECODE (y.ok_rmkk_tmkk, 1, 'да', '') ok_rmkk_tmkk,
                 DECODE (y.ok_dpu, 1, 'да', '') ok_dpu,
                 DECODE (y.ok_fin_man, 1, 'да', '') ok_fin_man
            FROM nets n, nets_plan_year y
           WHERE     n.id_net = y.id_net(+)
                 AND y.YEAR(+) = :y
                 AND y.plan_type = :plan_type
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
                 AND DECODE ( :tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
                 AND DECODE ( :tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
        ORDER BY n.net_name) z