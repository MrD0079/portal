/* Formatted on 13/10/2015 12:53:22 (QP5 v5.252.13127.32867) */
SELECT SUM (plan) plan,
       SUM (fakt) fakt,
       SUM (zatr) zatr,
       DECODE (SUM (fakt), 0, 0, SUM (zatr) / SUM (fakt) * 100) perc_zatr
  FROM (  SELECT (SELECT PLAN
                    FROM networkplanfact
                   WHERE     YEAR = :y
                         AND MONTH = :plan_month
                         AND id_net = (SELECT sw_kod
                                         FROM nets
                                        WHERE id_net = :net))
                    PLAN,
                 SUM (m.total) zatr,
                 (SELECT fakt
                    FROM networkplanfact
                   WHERE     YEAR = :y
                         AND MONTH = :plan_month
                         AND id_net = (SELECT sw_kod
                                         FROM nets
                                        WHERE id_net = :net))
                    fakt
            FROM nets_plan_month m, month_koeff mk
           WHERE     m.YEAR(+) = :y
                 AND DECODE ( :plan_month, 0, mk.MONTH, :plan_month) =
                        mk.MONTH
                 AND m.id_net(+) = :net
                 AND m.plan_type(+) = :plan_type
                 AND mk.MONTH = m.MONTH(+)
        GROUP BY mk.month_name, mk.koeff, mk.MONTH
        ORDER BY mk.MONTH)