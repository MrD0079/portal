/* Formatted on 17/06/2015 13:05:52 (QP5 v5.227.12220.39724) */
SELECT SUM (DECODE (z.no_budget, NULL, 0, 1)) no_budget,
       SUM (z.year_budget_fin) year_budget_fin,
       SUM (z.year_budget_dog) year_budget_dog,
       SUM (z.year_budget_oper) year_budget_oper
  FROM (SELECT n.tn_rmkk,
               n.tn_mkk,
               fn_getname (n.tn_rmkk) rmkk,
               fn_getname (n.tn_mkk) mkk,
               n.net_name,
               DECODE (
                  (SELECT no_budget
                     FROM nets_plan_year
                    WHERE YEAR = :y AND id_net = n.id_net AND plan_type = 1),
                  1, 'да',
                  '')
                  no_budget,
               NVL (
                  (SELECT SUM (total)
                     FROM nets_plan_month m, statya s
                    WHERE     m.YEAR = :y
                          AND DECODE (:MONTH, 0, m.MONTH, :MONTH) = m.MONTH
                          AND m.plan_type = 1
                          AND m.id_net = n.id_net
                          AND s.ID(+) = m.statya
                          AND DECODE (:payment_type,
                                      0, m.payment_type,
                                      :payment_type) = m.payment_type
                          AND s.PARENT IN (:GROUPS)),
                  0)
                  year_budget_fin,
               NVL (
                  (SELECT SUM (total)
                     FROM nets_plan_month m, statya s
                    WHERE     m.YEAR = :y
                          AND DECODE (:MONTH, 0, m.MONTH, :MONTH) = m.MONTH
                          AND m.plan_type = 2
                          AND m.id_net = n.id_net
                          AND s.ID(+) = m.statya
                          AND DECODE (:payment_type,
                                      0, m.payment_type,
                                      :payment_type) = m.payment_type
                          AND s.PARENT IN (:GROUPS)),
                  0)
                  year_budget_dog,
               NVL (
                  (SELECT SUM (total)
                     FROM nets_plan_month m, statya s
                    WHERE     m.YEAR = :y
                          AND DECODE (:MONTH, 0, m.MONTH, :MONTH) = m.MONTH
                          AND m.plan_type = 3
                          AND m.id_net = n.id_net
                          AND s.ID(+) = m.statya
                          AND DECODE (:payment_type,
                                      0, m.payment_type,
                                      :payment_type) = m.payment_type
                          AND s.PARENT IN (:GROUPS)),
                  0)
                  year_budget_oper
          FROM nets n
         WHERE     :tn IN (DECODE ( (SELECT pos_id
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
               AND DECODE (:tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
               AND DECODE (:tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
               AND (   n.id_net IN
                          (SELECT kk_flt_nets_detail.id_net
                             FROM kk_flt_nets, kk_flt_nets_detail
                            WHERE     kk_flt_nets.id = :flt_id
                                  AND kk_flt_nets.id =
                                         kk_flt_nets_detail.id_flt)
                    OR :flt_id = 0)) z