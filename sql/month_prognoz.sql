/* Formatted on 2011/12/23 08:11 (Formatter Plus v4.8.8) */
SELECT   mk.MONTH,
         mk.month_name,
         mk.koeff,
         (SELECT sales
            FROM nets_plan_year
           WHERE YEAR = :YEAR
             AND plan_type = :plan_type
             AND id_net = :net) * koeff / 100 summa,
         SUM(m.total) zatr,
         DECODE((SELECT sales
                   FROM nets_plan_year
                  WHERE YEAR = :YEAR
                    AND plan_type = :plan_type
                    AND id_net = :net),
                0, 0,
                SUM(m.total) /((SELECT sales
                                  FROM nets_plan_year
                                 WHERE YEAR = :YEAR
                                   AND plan_type = :plan_type
                                   AND id_net = :net) * koeff / 100) * 100
               ) perc_zatr
    FROM nets_plan_month m,
         month_koeff mk
   WHERE m.YEAR(+) = :YEAR
     AND m.id_net(+) = :net
     AND m.plan_type(+) = :plan_type
     AND mk.MONTH = m.MONTH(+)
GROUP BY mk.month_name,
         mk.koeff,
         mk.MONTH
ORDER BY mk.MONTH