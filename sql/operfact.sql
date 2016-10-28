/* Formatted on 12/3/2015 5:03:49  (QP5 v5.252.13127.32867) */
  SELECT n.id_net,
         n.net_name,
         n.PLAN PLAN,
         n.fakt fakt,
         pf.pay_format,
         st.payment_format,
         SUM (oper.cnt) o_cnt,
         SUM (oper.total) o_total,
         SUM (oper.bonus) o_bonus,
         SUM (fu.cnt) fu_cnt,
         SUM (
            CASE
               WHEN :reptype = 1
               THEN
                  fu.total
               WHEN :reptype = 2
               THEN
                  CASE
                     WHEN st.payment_format = 1 THEN oper.bonus / 100 * n.fakt
                     WHEN st.payment_format = 2 THEN oper.total
                  END
            END)
            fu_total,
         SUM (fu.bonus) fu_bonus
    FROM (SELECT n1.*, pf1.PLAN, pf1.fakt / 1000 fakt
            FROM nets n1,
                 (  SELECT SUM (
                              CASE
                                 WHEN :mgroups = 1 THEN plan
                                 WHEN :mgroups = 3 THEN plan_ng
                                 WHEN :mgroups = 2 THEN plan_coffee
                              END)
                              PLAN,
                           SUM (
                              CASE
                                 WHEN :mgroups = 1 THEN fakt
                                 WHEN :mgroups = 3 THEN fakt_ng
                                 WHEN :mgroups = 2 THEN fakt_coffee
                              END)
                              fakt,
                           (SELECT id_net
                              FROM nets
                             WHERE sw_kod = npf.id_net)
                              id_net
                      FROM networkplanfact npf
                     WHERE     DECODE ( :calendar_months,
                                       0, MONTH,
                                       :calendar_months) = MONTH
                           AND YEAR = :y
                  GROUP BY npf.id_net) pf1
           WHERE n1.id_net = pf1.id_net(+)) n,
         nets_plan_year y,
         (SELECT DISTINCT y
            FROM calendar
           WHERE y = :y) cm,
         (SELECT DISTINCT statya, id_net, payment_format
            FROM nets_plan_month m, statya s
           WHERE     plan_type IN (3, 4)
                 AND CASE
                        WHEN s.parent NOT IN (42, 96882041) THEN 1
                        WHEN s.parent = 96882041 THEN 2
                        WHEN s.parent = 42 THEN 3
                     END IN ( :mgroups)
                 AND m.statya = s.id
                 AND DECODE ( :calendar_months, 0, MONTH, :calendar_months) =
                        MONTH
                 AND YEAR = :y) st,
         statya sn,
         (  SELECT statya,
                   id_net,
                   SUM (cnt) cnt,
                   SUM (total) total,
                   SUM (bonus) bonus,
                   payment_format
              FROM nets_plan_month m, statya s
             WHERE     plan_type = 3
                   AND CASE
                          WHEN s.parent NOT IN (42, 96882041) THEN 1
                          WHEN s.parent = 96882041 THEN 2
                          WHEN s.parent = 42 THEN 3
                       END IN ( :mgroups)
                   AND m.statya = s.id
                   AND DECODE ( :calendar_months, 0, MONTH, :calendar_months) =
                          MONTH
                   AND YEAR = :y
          GROUP BY statya, id_net, payment_format) oper,
         (  SELECT statya,
                   id_net,
                   SUM (cnt) cnt,
                   SUM (total) total,
                   SUM (bonus) bonus,
                   payment_format
              FROM nets_plan_month m, statya s
             WHERE     plan_type = 4
                   AND CASE
                          WHEN s.parent NOT IN (42, 96882041) THEN 1
                          WHEN s.parent = 96882041 THEN 2
                          WHEN s.parent = 42 THEN 3
                       END IN ( :mgroups)
                   AND m.statya = s.id
                   AND DECODE ( :calendar_months, 0, MONTH, :calendar_months) =
                          MONTH
                   AND YEAR = :y
          GROUP BY statya, id_net, payment_format) fu,
         payment_format pf
   WHERE     pf.id = st.payment_format
         AND n.id_net = y.id_net
         AND y.YEAR = :y
         AND y.plan_type = 1
         AND cm.y = y.YEAR
         AND sn.ID = st.statya
         AND st.id_net = y.id_net
         AND st.statya = oper.statya(+)
         AND st.id_net = oper.id_net(+)
         AND st.payment_format = oper.payment_format(+)
         AND st.statya = fu.statya(+)
         AND st.id_net = fu.id_net(+)
         AND st.payment_format = fu.payment_format(+)
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
                          WHERE tn = :tn AND (is_super = 1 OR is_admin = 1)), :tn))
         AND DECODE ( :tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
         AND DECODE ( :tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
         AND DECODE ( :nets, 0, n.id_net, :nets) = n.id_net
GROUP BY n.id_net,
         n.net_name,
         n.PLAN,
         n.fakt,
         pf.pay_format,
         st.payment_format
ORDER BY n.net_name, pf.pay_format