/* Formatted on 20/11/2015 9:48:29 AM (QP5 v5.252.13127.32867) */
  SELECT DECODE ( :plan_type,
                 3, (SELECT NVL (SUM (PLAN), 0)
                       FROM networkplanfact
                      WHERE     id_net = (SELECT sw_kod
                                            FROM nets
                                           WHERE id_net = :net)
                            AND YEAR = :YEAR),
                 y.sales)
            sales,
         DECODE ( :plan_type,
                 3, (SELECT NVL (SUM (PLAN), 0)
                       FROM networkplanfact
                      WHERE     id_net = (SELECT sw_kod
                                            FROM nets
                                           WHERE id_net = :net)
                            AND YEAR = :YEAR),
                 y.sales_ng)
            sales_ng,
         DECODE ( :plan_type,
                 3, (SELECT NVL (SUM (PLAN), 0)
                       FROM networkplanfact
                      WHERE     id_net = (SELECT sw_kod
                                            FROM nets
                                           WHERE id_net = :net)
                            AND YEAR = :YEAR),
                 y.sales_coffee)
            sales_coffee,
         SUM (m.total) zatr,
           DECODE (DECODE ( :plan_type,
                           3, (SELECT NVL (SUM (PLAN), 0)
                                 FROM networkplanfact
                                WHERE     id_net = (SELECT sw_kod
                                                      FROM nets
                                                     WHERE id_net = :net)
                                      AND YEAR = :YEAR),
                           y.sales),
                   0, 0,
                     SUM (m.total)
                   / DECODE ( :plan_type,
                             3, (SELECT NVL (SUM (PLAN), 0)
                                   FROM networkplanfact
                                  WHERE     id_net = (SELECT sw_kod
                                                        FROM nets
                                                       WHERE id_net = :net)
                                        AND YEAR = :YEAR),
                             y.sales))
         * 100
            perc,
         y.ok_rmkk_tmkk,
         y.ok_fin_man,
         y.sales_prev,
         y.sales_prev_ng,
         y.sales_prev_coffee
    FROM nets_plan_year y,
         nets_plan_month m,
         (SELECT DISTINCT y
            FROM calendar
           WHERE y = :YEAR) c
   WHERE     y.YEAR(+) = c.y
         AND y.plan_type(+) = :plan_type
         AND y.id_net(+) = :net
         AND c.y = m.YEAR(+)
         AND :net = m.id_net(+)
         AND :plan_type = m.plan_type(+)
GROUP BY c.y,
         y.sales,
         y.sales_prev,
         y.sales_ng,
         y.sales_prev_ng,
         y.sales_coffee,
         y.sales_prev_coffee,
         y.ok_rmkk_tmkk,
         y.ok_fin_man