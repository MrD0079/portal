/* Formatted on 11.01.2013 13:03:52 (QP5 v5.163.1008.3004) */
SELECT SUM (z.year_plan) year_plan,
       SUM (z.budget_fin_plan) budget_fin_plan,
       SUM (z.budget_dog_plan) budget_dog_plan,
       SUM (z.budget_sdu) budget_sdu,
       SUM (z.budget_sdu_last) budget_sdu_last,
       SUM (NVL (z.budget_sdu, 0) - NVL (z.budget_fin_plan, 0)) budget_delta_fin,
       SUM (NVL (z.budget_sdu_last, 0) - NVL (z.budget_dog_plan, 0)) budget_delta_dog,
       SUM (DECODE (no_budget, 1, 1, 0)) no_budget
  FROM (SELECT NVL (y.sales, 0) year_plan,
               (SELECT SUM (NVL (total, 0))
                  FROM nets_plan_month m
                 WHERE m.YEAR = :y AND m.plan_type = 1 AND m.id_net = n.id_net)
                  budget_fin_plan,
               (SELECT SUM (NVL (total, 0))
                  FROM nets_plan_month m
                 WHERE m.YEAR = :y AND m.plan_type = 2 AND m.id_net = n.id_net)
                  budget_dog_plan,
               (SELECT SUM (CASE pay_format
                               WHEN 1
                               THEN
                                    (SELECT NVL (sales, 0)
                                       FROM nets_plan_year y
                                      WHERE y.YEAR = :y AND y.plan_type = 1 AND y.id_net = n.id_net)
                                  / 100
                                  * summa
                               WHEN 2
                               THEN
                                  summa
                            END)
                          b_perc
                  FROM sdu_terms_year
                 WHERE id_net = n.id_net AND ver = 1 AND YEAR = :y)
                  budget_sdu,
               (SELECT SUM (CASE pay_format
                               WHEN 1
                               THEN
                                    (SELECT NVL (sales, 0)
                                       FROM nets_plan_year y
                                      WHERE y.YEAR = :y AND y.plan_type = 1 AND y.id_net = n.id_net)
                                  / 100
                                  * summa
                               WHEN 2
                               THEN
                                  summa
                            END)
                          b_perc
                  FROM sdu_terms_year
                 WHERE     id_net = n.id_net
                       AND ver = (SELECT NVL (MAX (ver), 0)
                                    FROM sdu
                                   WHERE id_net = n.id_net AND year = :y)
                       AND YEAR = :y)
                  budget_sdu_last,
               no_budget
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
                                      WHERE tn = :tn AND is_super = 1), :tn))
               AND DECODE (:tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
               AND DECODE (:tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk) z