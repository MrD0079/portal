/* Formatted on 17/06/2015 12:57:15 (QP5 v5.227.12220.39724) */
SELECT ROWNUM,
       DECODE (ROUND (ROWNUM / 10 - 0.5) * 10 + 1 - ROWNUM, 0, 1, 0)
          draw_head,
       DECODE (ROUND (ROWNUM / 2) * 2, ROWNUM, 1, 0) color,
       z.*,
       DECODE (z.year_plan, 0, 0, z.year_budget / z.year_plan * 100)
          perc_zatr
  FROM (  SELECT n.tn_rmkk,
                 n.tn_mkk,
                 fn_getname (n.tn_rmkk) rmkk,
                 fn_getname (n.tn_mkk) mkk,
                 n.net_name,
                 DECODE (
                    :plan_type,
                    3, (SELECT NVL (SUM (PLAN), 0)
                          FROM networkplanfact
                         WHERE     id_net = (SELECT sw_kod
                                               FROM nets
                                              WHERE id_net = n.id_net)
                               AND DECODE (:MONTH, 0, MONTH, :MONTH) = MONTH
                               AND YEAR = :y),
                    NVL (  y.sales
                         * (SELECT SUM (koeff) / 100
                              FROM month_koeff
                             WHERE DECODE (:MONTH, 0, MONTH, :MONTH) = MONTH),
                         0))
                    year_plan,
                 NVL (
                    (SELECT SUM (total)
                       FROM nets_plan_month m, statya s
                      WHERE     m.YEAR = :y
                            AND DECODE (:MONTH, 0, m.MONTH, :MONTH) = m.MONTH
                            AND m.plan_type = :plan_type
                            AND m.id_net = n.id_net
                            AND s.ID(+) = m.statya
                            AND DECODE (:payment_type,
                                        0, m.payment_type,
                                        :payment_type) = m.payment_type
                            AND s.PARENT IN (:GROUPS)),
                    0)
                    year_budget
            FROM nets n,
                 (SELECT y.*
                    FROM (SELECT DISTINCT y FROM calendar) c, nets_plan_year y
                   WHERE     c.y = :y
                         AND y.YEAR(+) = c.y
                         AND y.plan_type(+) = :plan_type) y
           WHERE     y.id_net(+) = n.id_net
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
                 AND DECODE (:net, 0, n.id_net, :net) = n.id_net
                 AND DECODE (:tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
                 AND DECODE (:tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
                 AND (   n.id_net IN
                            (SELECT kk_flt_nets_detail.id_net
                               FROM kk_flt_nets, kk_flt_nets_detail
                              WHERE     kk_flt_nets.id = :flt_id
                                    AND kk_flt_nets.id =
                                           kk_flt_nets_detail.id_flt)
                      OR :flt_id = 0)
        ORDER BY DECODE (:orderby, 1, net_name, NULL),
                 DECODE (
                    :orderby,
                    2, DECODE (
                          :plan_type,
                          3, (SELECT NVL (SUM (PLAN), 0)
                                FROM networkplanfact
                               WHERE     id_net = (SELECT sw_kod
                                                     FROM nets
                                                    WHERE id_net = n.id_net)
                                     AND DECODE (:MONTH, 0, MONTH, :MONTH) =
                                            MONTH
                                     AND YEAR = :y),
                          NVL (
                               y.sales
                             * (SELECT SUM (koeff) / 100
                                  FROM month_koeff
                                 WHERE DECODE (:MONTH, 0, MONTH, :MONTH) =
                                          MONTH),
                             0)),
                    NULL) DESC,
                 DECODE (
                    :orderby,
                    3, DECODE (
                          DECODE (
                             :plan_type,
                             3, (SELECT NVL (SUM (PLAN), 0)
                                   FROM networkplanfact
                                  WHERE     id_net =
                                               (SELECT sw_kod
                                                  FROM nets
                                                 WHERE id_net = n.id_net)
                                        AND DECODE (:MONTH, 0, MONTH, :MONTH) =
                                               MONTH
                                        AND YEAR = :y),
                             NVL (
                                  y.sales
                                * (SELECT SUM (koeff) / 100
                                     FROM month_koeff
                                    WHERE DECODE (:MONTH, 0, MONTH, :MONTH) =
                                             MONTH),
                                0)),
                          0, 0,
                            NVL (
                               (SELECT SUM (total)
                                  FROM nets_plan_month m, statya s
                                 WHERE     m.YEAR = :y
                                       AND DECODE (:MONTH,
                                                   0, m.MONTH,
                                                   :MONTH) = m.MONTH
                                       AND m.plan_type = :plan_type
                                       AND m.id_net = n.id_net
                                       AND s.ID(+) = m.statya
                                       AND DECODE (:payment_type,
                                                   0, m.payment_type,
                                                   :payment_type) =
                                              m.payment_type
                                       AND s.PARENT IN (:GROUPS)),
                               0)
                          / DECODE (
                               :plan_type,
                               3, (SELECT NVL (SUM (PLAN), 0)
                                     FROM networkplanfact
                                    WHERE     id_net =
                                                 (SELECT sw_kod
                                                    FROM nets
                                                   WHERE id_net = n.id_net)
                                          AND DECODE (:MONTH,
                                                      0, MONTH,
                                                      :MONTH) = MONTH
                                          AND YEAR = :y),
                               NVL (  y.sales
                                    * (SELECT SUM (koeff) / 100
                                         FROM month_koeff
                                        WHERE DECODE (:MONTH,
                                                      0, MONTH,
                                                      :MONTH) = MONTH),
                                    0))
                          * 100),
                    NULL) DESC) z