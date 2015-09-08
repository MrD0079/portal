/* Formatted on 11.01.2013 13:27:00 (QP5 v5.163.1008.3004) */
SELECT ROWNUM, DECODE (ROUND (ROWNUM / 10 - 0.5) * 10 + 1 - ROWNUM, 0, 1, 0) draw_head, z.*
  FROM (  SELECT n.tn_rmkk,
                 n.tn_mkk,
                 fn_getname ( n.tn_rmkk) rmkk,
                 fn_getname ( n.tn_mkk) mkk,
                 n.net_name,
                 DECODE (y.no_budget, 1, 'да', '') no_budget,
                 n.id_net,
                 DECODE (du_complete, 1, 'да (' || TO_CHAR (du_complete_date, 'dd.mm.yyyy') || ')', NULL) du_complete,
                 dt.dus_type_name,
                 DECODE ( (SELECT ok_fin_man
                             FROM nets_plan_year
                            WHERE YEAR = :y AND plan_type = 2 AND id_net = n.id_net),
                         1, 'да',
                         '')
                    ok_fin_man
            FROM nets n, nets_plan_year y, nets_dus_types dt
           WHERE     n.id_net = y.id_net(+)
                 AND y.YEAR(+) = :y
                 AND y.plan_type = :plan_type
                 AND y.dus_type = dt.ID(+)
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
                 AND DECODE (:all_nets,  0, y.no_budget,  1, 0,  2, 1) = y.no_budget
        ORDER BY n.net_name) z