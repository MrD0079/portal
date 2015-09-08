/* Formatted on 11.01.2013 13:30:31 (QP5 v5.163.1008.3004) */
  SELECT y.no_budget,
         n.tn_rmkk,
         n.tn_mkk,
         n.id_net,
         n.net_name,
         fn_getname ( n.tn_rmkk) rmkk,
         fn_getname ( n.tn_mkk) mkk,
         cm.my,
         cm.mt,
         (SELECT ok_rmkk_tmkk
            FROM nets_plan_month_ok
           WHERE YEAR = :y AND id_net = n.id_net AND MONTH = cm.my AND plan_type = 3)
            ok_rmkk_tmkk,
         (SELECT ok_nmkk
            FROM nets_plan_month_ok
           WHERE YEAR = :y AND id_net = n.id_net AND MONTH = cm.my AND plan_type = 3)
            ok_nmkk,
         (SELECT ok_dpu
            FROM nets_plan_month_ok
           WHERE YEAR = :y AND id_net = n.id_net AND MONTH = cm.my AND plan_type = 3)
            ok_dpu,
         (SELECT msg
            FROM nets_plan_month_ok
           WHERE YEAR = :y AND id_net = n.id_net AND MONTH = cm.my AND plan_type = 3)
            msg
    FROM nets n,
         nets_plan_year y,
         (SELECT DISTINCT y, my, mt
            FROM calendar
           WHERE y = :y) cm
   WHERE     n.id_net = y.id_net
         AND y.YEAR = :y
         AND y.plan_type = 1
         AND cm.y = y.YEAR
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
         AND DECODE (:neednmkk,
                     0, CASE
                           WHEN NVL (y.sales, 0) >= (SELECT val_number
                                                       FROM PARAMETERS
                                                      WHERE LOWER (param_name) = LOWER ('valNMKK') AND dpt_id = :dpt_id)
                                OR DECODE (NVL (y.sales, 0),
                                           0, 0,
                                             (SELECT NVL (SUM (total), 0)
                                                FROM nets_plan_month m
                                               WHERE m.YEAR = :y AND m.plan_type = 1 AND m.id_net = n.id_net)
                                           / y.sales
                                           * 100) >= (SELECT val_number
                                                        FROM PARAMETERS
                                                       WHERE LOWER (param_name) = LOWER ('budKK') AND dpt_id = :dpt_id)
                           THEN
                              1
                           ELSE
                              0
                        END,
                     :neednmkk) = CASE
                                     WHEN NVL (y.sales, 0) >= (SELECT val_number
                                                                 FROM PARAMETERS
                                                                WHERE LOWER (param_name) = LOWER ('valNMKK') AND dpt_id = :dpt_id)
                                          OR DECODE (NVL (y.sales, 0),
                                                     0, 0,
                                                       (SELECT NVL (SUM (total), 0)
                                                          FROM nets_plan_month m
                                                         WHERE m.YEAR = :y AND m.plan_type = 1 AND m.id_net = n.id_net)
                                                     / y.sales
                                                     * 100) >= (SELECT val_number
                                                                  FROM PARAMETERS
                                                                 WHERE LOWER (param_name) = LOWER ('budKK') AND dpt_id = :dpt_id)
                                     THEN
                                        1
                                     ELSE
                                        0
                                  END
         AND DECODE (:calendar_months, 0, cm.my, :calendar_months) = cm.my
         AND DECODE (:ok_filter,
                     0, 0,
                     1, (SELECT ok_rmkk_tmkk
                           FROM nets_plan_month_ok
                          WHERE YEAR = :y AND id_net = n.id_net AND MONTH = cm.my AND plan_type = 3),
                     2, (SELECT ok_nmkk
                           FROM nets_plan_month_ok
                          WHERE YEAR = :y AND id_net = n.id_net AND MONTH = cm.my AND plan_type = 3),
                     3, (SELECT ok_dpu
                           FROM nets_plan_month_ok
                          WHERE YEAR = :y AND id_net = n.id_net AND MONTH = cm.my AND plan_type = 3)) = 0
ORDER BY n.net_name, cm.my