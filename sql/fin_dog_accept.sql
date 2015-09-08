/* Formatted on 08/12/2014 12:15:57 (QP5 v5.227.12220.39724) */
SELECT ROWNUM,
       DECODE (ROUND (ROWNUM / 10 - 0.5) * 10 + 1 - ROWNUM, 0, 1, 0)
          draw_head,
       z.*
  FROM (  SELECT n.tn_rmkk,
                 n.tn_mkk,
                 fn_getname ( n.tn_rmkk) rmkk,
                 fn_getname ( n.tn_mkk) mkk,
                 n.id_net,
                 n.net_name,
                 (SELECT CASE
                            WHEN    NVL (y.sales, 0) >=
                                       (SELECT val_number
                                          FROM PARAMETERS
                                         WHERE     LOWER (param_name) =
                                                      LOWER ('valNMKK')
                                               AND dpt_id = :dpt_id)
                                 OR DECODE (
                                       NVL (y.sales, 0),
                                       0, 0,
                                         (SELECT NVL (SUM (total), 0)
                                            FROM nets_plan_month m
                                           WHERE     m.YEAR = :y
                                                 AND m.plan_type = 1
                                                 AND m.id_net = n.id_net)
                                       / y.sales
                                       * 100) >=
                                       (SELECT val_number
                                          FROM PARAMETERS
                                         WHERE     LOWER (param_name) =
                                                      LOWER ('budKK')
                                               AND dpt_id = :dpt_id)
                            THEN
                               1
                            ELSE
                               0
                         END
                    FROM DUAL)
                    neednmkk,
                 DECODE (y.no_budget, 1, 'да', '') no_budget,
                 NVL (y.sales_prev, 0) prev_year_fakt,
                 NVL (y.sales, 0) year_plan,
                 DECODE (NVL (y.sales_prev, 0),
                         0, 0,
                         (y.sales / y.sales_prev - 1) * 100)
                    perc_rost,
                 (SELECT NVL (SUM (total), 0)
                    FROM nets_plan_month m
                   WHERE     m.YEAR = :y
                         AND m.plan_type = 1
                         AND m.id_net = n.id_net)
                    budget,
                 (SELECT NVL (SUM (total), 0)
                    FROM nets_plan_month m
                   WHERE     m.YEAR = :y
                         AND m.plan_type = 2
                         AND m.id_net = n.id_net)
                    budget_dog,
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
                 (SELECT NVL (SUM (total), 0)
                    FROM nets_plan_month m
                   WHERE     m.YEAR = :y - 1
                         AND m.plan_type = 1
                         AND m.id_net = n.id_net)
                    prev_year_budget,
                 DECODE (
                    NVL (
                       (SELECT SUM (total)
                          FROM nets_plan_month m
                         WHERE     m.YEAR = :y - 1
                               AND m.plan_type = 1
                               AND m.id_net = n.id_net),
                       0),
                    0, 0,
                        (SELECT SUM (total)
                           FROM nets_plan_month m
                          WHERE     m.YEAR = :y
                                AND m.plan_type = 1
                                AND m.id_net = n.id_net)
                      / (SELECT SUM (total)
                           FROM nets_plan_month m
                          WHERE     m.YEAR = :y - 1
                                AND m.plan_type = 1
                                AND m.id_net = n.id_net)
                      * 100
                    - 100)
                    budget_rost,
                 DECODE (
                    NVL (
                       (SELECT SUM (total)
                          FROM nets_plan_month m
                         WHERE     m.YEAR = :y - 1
                               AND m.plan_type = 2
                               AND m.id_net = n.id_net),
                       0),
                    0, 0,
                        (SELECT SUM (total)
                           FROM nets_plan_month m
                          WHERE     m.YEAR = :y
                                AND m.plan_type = 2
                                AND m.id_net = n.id_net)
                      / (SELECT SUM (total)
                           FROM nets_plan_month m
                          WHERE     m.YEAR = :y - 1
                                AND m.plan_type = 2
                                AND m.id_net = n.id_net)
                      * 100
                    - 100)
                    budget_dog_rost,
                 DECODE (
                    NVL (y.sales, 0),
                    0, 0,
                      (SELECT NVL (SUM (total), 0)
                         FROM nets_plan_month m
                        WHERE     m.YEAR = :y
                              AND m.plan_type = 1
                              AND m.id_net = n.id_net)
                    / y.sales
                    * 100)
                    perc_zatr,
                 DECODE (
                    NVL (y.sales, 0),
                    0, 0,
                      (SELECT NVL (SUM (total), 0)
                         FROM nets_plan_month m
                        WHERE     m.YEAR = :y
                              AND m.plan_type = 2
                              AND m.id_net = n.id_net)
                    / y.sales
                    * 100)
                    perc_zatr_dog,
                 y.ok_rmkk_tmkk ok_rmkk_tmkk,
                 y.ok_dpu ok_dpu,
                 y.ok_fin_man ok_fin_man,
                 DECODE (
                    y.du_complete,
                    1,    'да ('
                       || TO_CHAR (y.du_complete_date, 'dd.mm.yyyy')
                       || ')',
                    NULL)
                    du_complete,
                 dog.ok_fin_man ok_fin_man_dog
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
                                       WHERE tn = :tn AND is_super = 1), :tn))
                 AND DECODE (:tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
                 AND DECODE (:tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
                 AND DECODE (:nets, 0, n.id_net, :nets) = n.id_net
                 AND DECODE (
                        :neednmkk,
                        0, CASE
                              WHEN    NVL (y.sales, 0) >=
                                         (SELECT val_number
                                            FROM PARAMETERS
                                           WHERE     LOWER (param_name) =
                                                        LOWER ('valNMKK')
                                                 AND dpt_id = :dpt_id)
                                   OR DECODE (
                                         NVL (y.sales, 0),
                                         0, 0,
                                           (SELECT NVL (SUM (total), 0)
                                              FROM nets_plan_month m
                                             WHERE     m.YEAR = :y
                                                   AND m.plan_type = 1
                                                   AND m.id_net = n.id_net)
                                         / y.sales
                                         * 100) >=
                                         (SELECT val_number
                                            FROM PARAMETERS
                                           WHERE     LOWER (param_name) =
                                                        LOWER ('budKK')
                                                 AND dpt_id = :dpt_id)
                              THEN
                                 1
                              ELSE
                                 0
                           END,
                        :neednmkk) =
                        CASE
                           WHEN    NVL (y.sales, 0) >=
                                      (SELECT val_number
                                         FROM PARAMETERS
                                        WHERE     LOWER (param_name) =
                                                     LOWER ('valNMKK')
                                              AND dpt_id = :dpt_id)
                                OR DECODE (
                                      NVL (y.sales, 0),
                                      0, 0,
                                        (SELECT NVL (SUM (total), 0)
                                           FROM nets_plan_month m
                                          WHERE     m.YEAR = :y
                                                AND m.plan_type = 1
                                                AND m.id_net = n.id_net)
                                      / y.sales
                                      * 100) >=
                                      (SELECT val_number
                                         FROM PARAMETERS
                                        WHERE     LOWER (param_name) =
                                                     LOWER ('budKK')
                                              AND dpt_id = :dpt_id)
                           THEN
                              1
                           ELSE
                              0
                        END
        ORDER BY n.net_name) z