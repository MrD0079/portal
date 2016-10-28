/* Formatted on 27/11/2015 6:05:35 PM (QP5 v5.252.13127.32867) */
  SELECT plan_type,
         plan_name,
         SUM (budget) budget,
         SUM (plan) plan,
         SUM (fakt) fakt
    FROM ( /* Formatted on 30/11/2015 11:40:05 AM (QP5 v5.252.13127.32867) */
  SELECT sc.my,
         sc.mt,
         sc.plan_type,
         sc.plan_name,
         SUM (NVL (budget.total, 0)) budget,
         DECODE (
            sc.plan_type,
            3, (SELECT NVL (
                          SUM (
                             CASE
                                WHEN :mgroups = 1 THEN plan
                                WHEN :mgroups = 3 THEN plan_ng
                                WHEN :mgroups = 2 THEN plan_coffee
                             END),
                          0)
                  FROM networkplanfact npf
                 WHERE     npf.YEAR = sc.y
                       AND npf.MONTH = sc.my
                       AND npf.id_net IN (SELECT sw_kod
                                            FROM nets n
                                           WHERE     :tn IN (DECODE (
                                                                (SELECT pos_id
                                                                   FROM spdtree
                                                                  WHERE svideninn =
                                                                           :tn),
                                                                24, n.tn_mkk,
                                                                34, n.tn_rmkk,
                                                                63, :tn,
                                                                65, :tn,
                                                                67, :tn,
                                                                (SELECT pos_id
                                                                   FROM user_list
                                                                  WHERE     tn =
                                                                               :tn
                                                                        AND is_super =
                                                                               1), :tn,
                                                                (SELECT pos_id
                                                                   FROM user_list
                                                                  WHERE     tn =
                                                                               :tn
                                                                        AND is_admin =
                                                                               1), :tn))
                                                 AND DECODE ( :tn_rmkk,
                                                             0, n.tn_rmkk,
                                                             :tn_rmkk) =
                                                        n.tn_rmkk
                                                 AND DECODE ( :tn_mkk,
                                                             0, n.tn_mkk,
                                                             :tn_mkk) =
                                                        n.tn_mkk
                                                 AND DECODE ( :net,
                                                             0, n.id_net,
                                                             :net) = n.id_net
                                                 AND (   n.id_net IN (SELECT kk_flt_nets_detail.id_net
                                                                        FROM kk_flt_nets,
                                                                             kk_flt_nets_detail
                                                                       WHERE     kk_flt_nets.id =
                                                                                    :flt_id
                                                                             AND kk_flt_nets.id =
                                                                                    kk_flt_nets_detail.id_flt)
                                                      OR :flt_id = 0))),
            (SELECT SUM (
                         CASE
                            WHEN :mgroups = 1 THEN sales
                            WHEN :mgroups = 3 THEN sales_ng
                            WHEN :mgroups = 2 THEN sales_coffee
                         END
                       / 100
                       * (SELECT CASE
                                    WHEN :mgroups = 1 THEN koeff
                                    WHEN :mgroups = 3 THEN koeff_ng
                                    WHEN :mgroups = 2 THEN koeff_coffee
                                 END
                            FROM month_koeff
                           WHERE MONTH = sc.my))
               FROM nets_plan_year y, nets n
              WHERE     y.YEAR = sc.y
                    AND y.id_net = n.id_net
                    AND :tn IN (DECODE (
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
                                     WHERE tn = :tn AND is_super = 1), :tn,
                                   (SELECT pos_id
                                      FROM user_list
                                     WHERE tn = :tn AND is_admin = 1), :tn))
                    AND DECODE ( :tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
                    AND DECODE ( :tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
                    AND DECODE ( :net, 0, n.id_net, :net) = n.id_net
                    AND (   n.id_net IN (SELECT kk_flt_nets_detail.id_net
                                           FROM kk_flt_nets, kk_flt_nets_detail
                                          WHERE     kk_flt_nets.id = :flt_id
                                                AND kk_flt_nets.id =
                                                       kk_flt_nets_detail.id_flt)
                         OR :flt_id = 0)
                    AND plan_type = sc.plan_type))
            PLAN,
           DECODE (
              sc.plan_type,
              3, (SELECT NVL (
                            SUM (
                               CASE
                                  WHEN :mgroups = 1 THEN fakt
                                  WHEN :mgroups = 3 THEN fakt_ng
                                  WHEN :mgroups = 2 THEN fakt_coffee
                               END),
                            0)
                    FROM networkplanfact npf
                   WHERE     npf.YEAR = sc.y
                         AND npf.MONTH = sc.my
                         AND npf.id_net IN (SELECT sw_kod
                                              FROM nets n
                                             WHERE     :tn IN (DECODE (
                                                                  (SELECT pos_id
                                                                     FROM spdtree
                                                                    WHERE svideninn =
                                                                             :tn),
                                                                  24, n.tn_mkk,
                                                                  34, n.tn_rmkk,
                                                                  63, :tn,
                                                                  65, :tn,
                                                                  67, :tn,
                                                                  (SELECT pos_id
                                                                     FROM user_list
                                                                    WHERE     tn =
                                                                                 :tn
                                                                          AND is_super =
                                                                                 1), :tn,
                                                                  (SELECT pos_id
                                                                     FROM user_list
                                                                    WHERE     tn =
                                                                                 :tn
                                                                          AND is_admin =
                                                                                 1), :tn))
                                                   AND DECODE ( :tn_rmkk,
                                                               0, n.tn_rmkk,
                                                               :tn_rmkk) =
                                                          n.tn_rmkk
                                                   AND DECODE ( :tn_mkk,
                                                               0, n.tn_mkk,
                                                               :tn_mkk) =
                                                          n.tn_mkk
                                                   AND DECODE ( :net,
                                                               0, n.id_net,
                                                               :net) = n.id_net
                                                   AND (   n.id_net IN (SELECT kk_flt_nets_detail.id_net
                                                                          FROM kk_flt_nets,
                                                                               kk_flt_nets_detail
                                                                         WHERE     kk_flt_nets.id =
                                                                                      :flt_id
                                                                               AND kk_flt_nets.id =
                                                                                      kk_flt_nets_detail.id_flt)
                                                        OR :flt_id = 0))),
              0)
         / 1000
            fakt
    FROM (SELECT s.PARENT,
                 s.ID,
                 s.cost_item,
                 c.*,
                 p.ID plan_type,
                 p.NAME plan_name
            FROM statya s,
                 (SELECT ID, NAME
                    FROM nets_plan_type
                   WHERE id IN (1, 2, 3)) p,
                 (SELECT DISTINCT y, my, mt
                    FROM calendar
                   WHERE y = :y) c
           WHERE     s.PARENT <> 0
                 /*AND s.PARENT IN ( :GROUPS)*/
                 AND CASE
                        WHEN s.parent NOT IN (42, 96882041) THEN 1
                        WHEN s.parent = 42 THEN 3
                        WHEN s.parent = 96882041 THEN 2
                     END IN ( :mgroups)
                 AND DECODE ( :statya_list, 0, s.ID, :statya_list) = s.ID) sc,
         (  SELECT SUM (total) total,
                   m.statya,
                   m.YEAR,
                   m.plan_type,
                   m.MONTH
              FROM statya s, nets_plan_month m, nets n
             WHERE     s.id = m.statya
                   AND CASE
                          WHEN s.parent NOT IN (42, 96882041) THEN 1
                          WHEN s.parent = 42 THEN 3
                          WHEN s.parent = 96882041 THEN 2
                       END IN ( :mgroups)
                   AND m.id_net = n.id_net
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
                   AND DECODE ( :net, 0, n.id_net, :net) = n.id_net
                   AND (   n.id_net IN (SELECT kk_flt_nets_detail.id_net
                                          FROM kk_flt_nets, kk_flt_nets_detail
                                         WHERE     kk_flt_nets.id = :flt_id
                                               AND kk_flt_nets.id =
                                                      kk_flt_nets_detail.id_flt)
                        OR :flt_id = 0)
                   AND DECODE ( :tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
                   AND DECODE ( :tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
                   AND m.YEAR = :y
                   AND DECODE ( :payment_type, 0, m.payment_type, :payment_type) =
                          m.payment_type
          GROUP BY m.statya,
                   m.YEAR,
                   m.plan_type,
                   m.MONTH) budget
   WHERE     sc.ID = budget.statya(+)
         AND sc.y = budget.YEAR(+)
         AND sc.plan_type = budget.plan_type(+)
         AND sc.my = budget.MONTH(+)
GROUP BY sc.y,
         sc.my,
         sc.mt,
         sc.plan_type,
         sc.plan_name
ORDER BY sc.my, sc.plan_type)
GROUP BY plan_type, plan_name
ORDER BY plan_type