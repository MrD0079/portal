/* Formatted on 13/10/2015 12:50:43 (QP5 v5.252.13127.32867) */
SELECT SUM (plan) plan,
       SUM (zatr) zatr,
       DECODE (SUM (plan), 0, 0, SUM (zatr) / SUM (plan) * 100) perc_zatr
  FROM (  SELECT   (SELECT sales
                      FROM nets_plan_year
                     WHERE     YEAR = :y
                           AND plan_type = :plan_type
                           AND id_net = :net)
                 * koeff
                 / 100
                    plan,
                 SUM (m.total) zatr
            FROM nets_plan_month m, month_koeff mk
           WHERE     m.YEAR(+) = :y
                 AND DECODE ( :plan_month, 0, mk.MONTH, :plan_month) =
                        mk.MONTH
                 AND m.id_net(+) = :net
                 AND m.plan_type(+) = :plan_type
                 AND mk.MONTH = m.MONTH(+)
        GROUP BY mk.month_name, mk.koeff, mk.MONTH
        ORDER BY mk.MONTH)