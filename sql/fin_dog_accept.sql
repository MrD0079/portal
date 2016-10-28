/* Formatted on 20/11/2015 12:11:13 PM (QP5 v5.252.13127.32867) */
  SELECT n.tn_rmkk,
         n.tn_mkk,
         fn_getname (n.tn_rmkk) rmkk,
         fn_getname (n.tn_mkk) mkk,
         n.id_net,
         n.net_name,
         y.no_budget no_budget_val,
         DECODE (y.no_budget, 1, 'да', '') no_budget,
         NVL (y.sales_prev, 0) prev_year_fakt,
         NVL (y.sales, 0) year_plan,
         NVL (y.sales_ng, 0) year_plan_ng,
         NVL (y.sales_coffee, 0) year_plan_coffee,
         NVL (y.sales_prev, 0) year_plan_prev,
         NVL (y.sales_prev_ng, 0) year_plan_prev_ng,
         NVL (y.sales_prev_coffee, 0) year_plan_prev_coffee,
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
           WHERE id_net = n.id_net AND ver = 1 AND YEAR = :y)
            budget_sdu,
         DECODE (NVL (y.sales_prev, 0),
                 0, 0,
                 (y.sales / y.sales_prev - 1) * 100)
            perc_rost,
         DECODE (NVL (y.sales_prev_ng, 0),
                 0, 0,
                 (y.sales_ng / y.sales_prev_ng - 1) * 100)
            perc_rost_ng,
         DECODE (NVL (y.sales_prev_coffee, 0),
                 0, 0,
                 (y.sales_coffee / y.sales_prev_coffee - 1) * 100)
            perc_rost_coffee,
         budget.budget,
         budget.budget_ng,
         budget.budget_coffee,
         budget.budget_dog,
         budget.budget_dog_ng,
         budget.budget_dog_coffee,
         budget.budget_prev,
         budget.budget_ng_prev,
         budget.budget_coffee_prev,
         budget.budget_dog_prev,
         budget.budget_dog_ng_prev,
         budget.budget_dog_coffee_prev,
         DECODE (NVL (budget.budget_prev, 0),
                 0, 0,
                 budget.budget / budget.budget_prev * 100 - 100)
            budget_rost,
         DECODE (NVL (budget.budget_ng_prev, 0),
                 0, 0,
                 budget.budget_ng / budget.budget_ng_prev * 100 - 100)
            budget_rost_ng,
         DECODE (NVL (budget.budget_coffee_prev, 0),
                 0, 0,
                 budget.budget_coffee / budget.budget_coffee_prev * 100 - 100)
            budget_rost_coffee,
         DECODE (NVL (budget.budget_dog_prev, 0),
                 0, 0,
                 budget.budget_dog / budget.budget_dog_prev * 100 - 100)
            budget_dog_rost,
         DECODE (NVL (budget.budget_dog_ng_prev, 0),
                 0, 0,
                 budget.budget_dog_ng / budget.budget_dog_ng_prev * 100 - 100)
            budget_dog_rost_ng,
         DECODE (
            NVL (budget.budget_dog_coffee_prev, 0),
            0, 0,
              budget.budget_dog_coffee / budget.budget_dog_coffee_prev * 100
            - 100)
            budget_dog_rost_coffee,
         DECODE (NVL (y.sales, 0), 0, 0, budget.budget / y.sales * 100)
            perc_zatr,
         DECODE (NVL (y.sales_ng, 0),
                 0, 0,
                 budget.budget_ng / y.sales_ng * 100)
            perc_zatr_ng,
         DECODE (NVL (y.sales_coffee, 0),
                 0, 0,
                 budget.budget_coffee / y.sales_coffee * 100)
            perc_zatr_coffee,
         DECODE (NVL (y.sales, 0), 0, 0, budget.budget_dog / y.sales * 100)
            perc_zatr_dog,
         DECODE (NVL (y.sales_ng, 0),
                 0, 0,
                 budget.budget_dog_ng / y.sales_ng * 100)
            perc_zatr_dog_ng,
         DECODE (NVL (y.sales_coffee, 0),
                 0, 0,
                 budget.budget_dog_coffee / y.sales_coffee * 100)
            perc_zatr_dog_coffee,
         y.ok_rmkk_tmkk ok_rmkk_tmkk,
         y.ok_dpu ok_dpu,
         y.ok_fin_man ok_fin_man,
         DECODE (
            y.du_complete,
            1, 'да (' || TO_CHAR (y.du_complete_date, 'dd.mm.yyyy') || ')',
            NULL)
            du_complete,
         y.du_complete du_complete_val,
         dog.ok_fin_man ok_fin_man_dog
    FROM nets n,
         nets_plan_year y,
         nets_plan_year dog,
         (  SELECT m.id_net,
                   SUM (
                      CASE
                         WHEN     m.YEAR = :y
                              AND m.plan_type = 1
                              AND m.statya IN (SELECT id
                                                 FROM statya
                                                WHERE parent NOT IN (42, 96882041))
                         THEN
                            NVL (total, 0)
                      END)
                      budget,
                   SUM (CASE
                           WHEN     m.YEAR = :y
                                AND m.plan_type = 1
                                AND m.statya IN (SELECT id
                                                   FROM statya
                                                  WHERE parent = 42)
                           THEN
                              NVL (total, 0)
                        END)
                      budget_ng,
                   SUM (CASE
                           WHEN     m.YEAR = :y
                                AND m.plan_type = 1
                                AND m.statya IN (SELECT id
                                                   FROM statya
                                                  WHERE parent = 96882041)
                           THEN
                              NVL (total, 0)
                        END)
                      budget_coffee,
                   SUM (
                      CASE
                         WHEN     m.YEAR = :y
                              AND m.plan_type = 2
                              AND m.statya IN (SELECT id
                                                 FROM statya
                                                WHERE parent NOT IN (42, 96882041))
                         THEN
                            NVL (total, 0)
                      END)
                      budget_dog,
                   SUM (CASE
                           WHEN     m.YEAR = :y
                                AND m.plan_type = 2
                                AND m.statya IN (SELECT id
                                                   FROM statya
                                                  WHERE parent = 42)
                           THEN
                              NVL (total, 0)
                        END)
                      budget_dog_ng,
                   SUM (CASE
                           WHEN     m.YEAR = :y
                                AND m.plan_type = 2
                                AND m.statya IN (SELECT id
                                                   FROM statya
                                                  WHERE parent = 96882041)
                           THEN
                              NVL (total, 0)
                        END)
                      budget_dog_coffee,
                   SUM (
                      CASE
                         WHEN     m.YEAR = :y - 1
                              AND m.plan_type = 1
                              AND m.statya IN (SELECT id
                                                 FROM statya
                                                WHERE parent NOT IN (42, 96882041))
                         THEN
                            NVL (total, 0)
                      END)
                      budget_prev,
                   SUM (CASE
                           WHEN     m.YEAR = :y - 1
                                AND m.plan_type = 1
                                AND m.statya IN (SELECT id
                                                   FROM statya
                                                  WHERE parent = 42)
                           THEN
                              NVL (total, 0)
                        END)
                      budget_ng_prev,
                   SUM (CASE
                           WHEN     m.YEAR = :y - 1
                                AND m.plan_type = 1
                                AND m.statya IN (SELECT id
                                                   FROM statya
                                                  WHERE parent = 96882041)
                           THEN
                              NVL (total, 0)
                        END)
                      budget_coffee_prev,
                   SUM (
                      CASE
                         WHEN     m.YEAR = :y - 1
                              AND m.plan_type = 2
                              AND m.statya IN (SELECT id
                                                 FROM statya
                                                WHERE parent NOT IN (42, 96882041))
                         THEN
                            NVL (total, 0)
                      END)
                      budget_dog_prev,
                   SUM (CASE
                           WHEN     m.YEAR = :y - 1
                                AND m.plan_type = 2
                                AND m.statya IN (SELECT id
                                                   FROM statya
                                                  WHERE parent = 42)
                           THEN
                              NVL (total, 0)
                        END)
                      budget_dog_ng_prev,
                   SUM (CASE
                           WHEN     m.YEAR = :y - 1
                                AND m.plan_type = 2
                                AND m.statya IN (SELECT id
                                                   FROM statya
                                                  WHERE parent = 96882041)
                           THEN
                              NVL (total, 0)
                        END)
                      budget_dog_coffee_prev
              FROM nets_plan_month m
             WHERE m.YEAR IN ( :y, :y - 1) AND m.plan_type IN (1, 2)
          GROUP BY m.id_net) budget
   WHERE     n.id_net = budget.id_net(+)
         AND n.id_net = y.id_net(+)
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
         AND DECODE ( :tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
         AND DECODE ( :tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
         AND DECODE ( :nets, 0, n.id_net, :nets) = n.id_net
ORDER BY n.net_name