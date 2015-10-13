/* Formatted on 08/12/2014 12:17:16 (QP5 v5.227.12220.39724) */
  SELECT SUM (DECODE (y.no_budget, 1, 1, 0)) no_budget,
         SUM (NVL (y.sales_prev, 0)) prev_year_fakt,
         SUM (NVL (y.sales, 0)) year_plan,
         DECODE (SUM (NVL (y.sales_prev, 0)),
                 0, 0,
                 (SUM (y.sales) / SUM (NVL (y.sales_prev, 0)) - 1) * 100)
            perc_rost,
         SUM (
            (SELECT SUM (total)
               FROM nets_plan_month m
              WHERE m.YEAR = y.YEAR AND m.plan_type = 1 AND m.id_net = n.id_net))
            budget,
         SUM (
            (SELECT SUM (total)
               FROM nets_plan_month m
              WHERE m.YEAR = y.YEAR AND m.plan_type = 2 AND m.id_net = n.id_net))
            budget_dog,
         SUM (
            (SELECT SUM (
                       CASE pay_format
                          WHEN 1
                          THEN
                               (SELECT NVL (sales, 0)
                                  FROM nets_plan_year y
                                 WHERE     y.YEAR = :y
                                       AND y.plan_type = 1
                                       AND y.id_net = n.id_net)
                             / 100
                             * summa
                          WHEN 2
                          THEN
                             summa
                       END)
                       b_perc
               FROM sdu_terms_year
              WHERE id_net = n.id_net AND ver = 1 AND YEAR = :y))
            budget_sdu,
         SUM (
            (SELECT SUM (total)
               FROM nets_plan_month m
              WHERE m.YEAR = :y - 1 AND m.plan_type = 1 AND m.id_net = n.id_net))
            prev_year_budget,
         DECODE (
            SUM (
               NVL (
                  (SELECT SUM (total)
                     FROM nets_plan_month m
                    WHERE     m.YEAR = :y - 1
                          AND m.plan_type = 1
                          AND m.id_net = n.id_net),
                  0)),
            0, 0,
                SUM (
                   (SELECT SUM (total)
                      FROM nets_plan_month m
                     WHERE     m.YEAR = :y
                           AND m.plan_type = 1
                           AND m.id_net = n.id_net))
              / SUM (
                   (SELECT SUM (total)
                      FROM nets_plan_month m
                     WHERE     m.YEAR = :y - 1
                           AND m.plan_type = 1
                           AND m.id_net = n.id_net))
              * 100
            - 100)
            budget_rost,
         DECODE (
            SUM (NVL (y.sales, 0)),
            0, 0,
              SUM (
                 (SELECT SUM (total)
                    FROM nets_plan_month m
                   WHERE     m.YEAR = :y
                         AND m.plan_type = 1
                         AND m.id_net = n.id_net))
            / SUM (NVL (y.sales, 0))
            * 100)
            perc_zatr,
         SUM (DECODE (y.ok_rmkk_tmkk, 1, 1, 0)) ok_rmkk_tmkk,
         SUM (DECODE (y.ok_dpu, 1, 1, 0)) ok_dpu,
         SUM (DECODE (y.ok_fin_man, 1, 1, 0)) ok_fin_man,
         SUM (y.du_complete) du_complete,
         SUM (DECODE (dog.ok_fin_man, 1, 1, 0)) ok_fin_man_dog
    FROM nets n, nets_plan_year y, nets_plan_year dog
   WHERE     n.id_net = y.id_net(+)
         AND y.YEAR(+) = :y
         AND y.plan_type = 1
         AND n.id_net = dog.id_net(+)
         AND dog.YEAR(+) = :y
         AND dog.plan_type(+) = 2
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
         AND DECODE (:tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
         AND DECODE (:tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
         AND DECODE (:nets, 0, n.id_net, :nets) = n.id_net
ORDER BY n.net_name