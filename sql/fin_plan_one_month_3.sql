/* Formatted on 15/06/2015 13:56:33 (QP5 v5.227.12220.39724) */
  SELECT (SELECT PLAN
            FROM networkplanfact
           WHERE     YEAR = :y
                 AND MONTH = :plan_month
                 AND id_net = (SELECT sw_kod
                                 FROM nets
                                WHERE id_net = :net))
            PLAN,
         SUM (m.total) zatr,
         DECODE ( (SELECT PLAN
                     FROM networkplanfact
                    WHERE     YEAR = :y
                          AND MONTH = :plan_month
                          AND id_net = (SELECT sw_kod
                                          FROM nets
                                         WHERE id_net = :net)),
                 0, 0,
                   SUM (m.total)
                 / (SELECT PLAN
                      FROM networkplanfact
                     WHERE     YEAR = :y
                           AND MONTH = :plan_month
                           AND id_net = (SELECT sw_kod
                                           FROM nets
                                          WHERE id_net = :net))
                 * 100)
            perc_zatr,
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
         AND m.id_net(+) = :net
         AND m.plan_type(+) = :plan_type
         AND mk.MONTH = m.MONTH(+)
         AND mk.MONTH = :plan_month
GROUP BY mk.month_name, mk.koeff, mk.MONTH
ORDER BY mk.MONTH