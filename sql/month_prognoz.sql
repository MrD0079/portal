/* Formatted on 19/11/2015 6:06:10 PM (QP5 v5.252.13127.32867) */
  SELECT mk.MONTH,
         mk.month_name,
         nets_plan_month_koeff ( :year, mk.month, :net) koeff,
         nets_plan_month_koeff ( :year,
                                mk.month,
                                :net,
                                1)
            koeff_ng,
         nets_plan_month_koeff ( :year,
                                mk.month,
                                :net,
                                2)
            koeff_coffee,
           (SELECT sales
              FROM nets_plan_year
             WHERE YEAR = :YEAR AND plan_type = :plan_type AND id_net = :net)
         * nets_plan_month_koeff ( :year, mk.month, :net)
         / 100
            summa,
           (SELECT sales_ng
              FROM nets_plan_year
             WHERE YEAR = :YEAR AND plan_type = :plan_type AND id_net = :net)
         * nets_plan_month_koeff ( :year,
                                  mk.month,
                                  :net,
                                  1)
         / 100
            summa_ng,
           (SELECT sales_coffee
              FROM nets_plan_year
             WHERE YEAR = :YEAR AND plan_type = :plan_type AND id_net = :net)
         * nets_plan_month_koeff ( :year,
                                  mk.month,
                                  :net,
                                  2)
         / 100
            summa_coffee,
         SUM (CASE WHEN s.parent NOT IN (42, 96882041) THEN m.total END) zatr,
         SUM (CASE WHEN s.parent = 42 THEN m.total END) zatr_ng,
         SUM (CASE WHEN s.parent = 96882041 THEN m.total END) zatr_coffee,
         DECODE (
            NVL (
                 (SELECT sales
                    FROM nets_plan_year
                   WHERE     YEAR = :YEAR
                         AND plan_type = :plan_type
                         AND id_net = :net)
               * nets_plan_month_koeff ( :year, mk.month, :net),
               0),
            0, 0,
              SUM (CASE WHEN s.parent <> 42 THEN m.total END)
            / (  (SELECT sales
                    FROM nets_plan_year
                   WHERE     YEAR = :YEAR
                         AND plan_type = :plan_type
                         AND id_net = :net)
               * nets_plan_month_koeff ( :year, mk.month, :net)
               / 100)
            * 100)
            perc_zatr,
         DECODE (
            NVL (
                 (SELECT sales_ng
                    FROM nets_plan_year
                   WHERE     YEAR = :YEAR
                         AND plan_type = :plan_type
                         AND id_net = :net)
               * nets_plan_month_koeff ( :year,
                                        mk.month,
                                        :net,
                                        1),
               0),
            0, 0,
              SUM (CASE WHEN s.parent = 42 THEN m.total END)
            / (  (SELECT sales_ng
                    FROM nets_plan_year
                   WHERE     YEAR = :YEAR
                         AND plan_type = :plan_type
                         AND id_net = :net)
               * nets_plan_month_koeff ( :year,
                                        mk.month,
                                        :net,
                                        1)
               / 100)
            * 100)
            perc_zatr_ng,
         DECODE (
            NVL (
                 (SELECT sales_coffee
                    FROM nets_plan_year
                   WHERE     YEAR = :YEAR
                         AND plan_type = :plan_type
                         AND id_net = :net)
               * nets_plan_month_koeff ( :year,
                                        mk.month,
                                        :net,
                                        2),
               0),
            0, 0,
              SUM (CASE WHEN s.parent = 96882041 THEN m.total END)
            / (  (SELECT sales_coffee
                    FROM nets_plan_year
                   WHERE     YEAR = :YEAR
                         AND plan_type = :plan_type
                         AND id_net = :net)
               * nets_plan_month_koeff ( :year,
                                        mk.month,
                                        :net,
                                        2)
               / 100)
            * 100)
            perc_zatr_coffee,
         NVL (o.ok_rmkk_tmkk, 1) ok_rmkk_tmkk
    FROM nets_plan_month m,
         month_koeff mk,
         statya s,
         nets_plan_month_ok o
   WHERE     m.YEAR(+) = :YEAR
         AND m.id_net(+) = :net
         AND m.plan_type(+) = :plan_type
         AND mk.MONTH = m.MONTH(+)
         AND m.statya = s.id(+)
         AND o.YEAR(+) = :YEAR
         AND o.id_net(+) = :net
         AND o.plan_type(+) = 1
         AND mk.MONTH = o.MONTH(+)
GROUP BY mk.month_name,
         mk.koeff,
         mk.koeff_ng,
         mk.koeff_coffee,
         mk.MONTH,
         o.ok_rmkk_tmkk
ORDER BY mk.MONTH