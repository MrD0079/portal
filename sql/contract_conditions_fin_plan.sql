/* Formatted on 16/10/2015 14:42:57 (QP5 v5.252.13127.32867) */
SELECT SUM (plan) plan,
       SUM (zatr) zatr,
       DECODE (SUM (plan), 0, 0, SUM (zatr) / SUM (plan) * 100) perc_zatr
  FROM (  SELECT   (SELECT SUM (sales)
                      FROM nets_plan_year
                     WHERE     YEAR = :y
                           AND plan_type = 2
                           AND id_net = DECODE ( :nets, 0, id_net, :nets))
                 * koeff
                 / 100
                    plan,
                 SUM (m.total) zatr
            FROM nets_plan_month m, month_koeff mk
           WHERE     m.YEAR = :y
                 AND m.id_net = DECODE ( :nets, 0, m.id_net, :nets)
                 AND m.plan_type = 2
                 AND mk.MONTH = m.MONTH
        GROUP BY mk.month_name, mk.koeff, mk.MONTH
        ORDER BY mk.MONTH)