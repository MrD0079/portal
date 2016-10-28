/* Formatted on 1/13/2016 11:58:02  (QP5 v5.252.13127.32867) */
SELECT SUM (plan) + SUM (plan_ng) + SUM (plan_coffee) plan_all,
       SUM (plan) plan,
       SUM (plan_ng) plan_ng,
       SUM (plan_coffee) plan_coffee,
       SUM (zatr) + SUM (zatr_ng) + SUM (zatr_coffee) zatr_all,
       SUM (zatr) zatr,
       SUM (zatr_ng) zatr_ng,
       SUM (zatr_coffee) zatr_coffee,
       DECODE (
          (SUM (plan) + SUM (plan_ng) + SUM (plan_coffee)),
          0, 0,
          (SUM (zatr) + SUM (zatr_ng) + SUM (zatr_coffee)) / (SUM (plan) + SUM (plan_ng) + SUM (plan_coffee)) * 100)
          perc_zatr_all,
       DECODE (SUM (plan), 0, 0, SUM (zatr) / SUM (plan) * 100) perc_zatr,
       DECODE (SUM (plan_ng), 0, 0, SUM (zatr_ng) / SUM (plan_ng) * 100)
          perc_zatr_ng,
       DECODE (SUM (plan_coffee),
               0, 0,
               SUM (zatr_coffee) / SUM (plan_coffee) * 100)
          perc_zatr_coffee
  FROM (  SELECT NVL (y.sales, 0) * mk.koeff / 100 plan,
                 NVL (
                    SUM (
                       CASE
                          WHEN s.parent NOT IN (42, 96882041) THEN m.total
                       END),
                    0)
                    zatr,
                 NVL (y.sales_ng, 0) * mk.koeff_ng / 100 plan_ng,
                 NVL (SUM (CASE WHEN s.parent = 42 THEN m.total END), 0)
                    zatr_ng,
                 NVL (y.sales_coffee, 0) * mk.koeff_coffee / 100 plan_coffee,
                 NVL (SUM (CASE WHEN s.parent = 96882041 THEN m.total END), 0)
                    zatr_coffee
            FROM statya s,
                 nets_plan_month m,
                 month_koeff mk,
                 nets_plan_year y
           WHERE     m.YEAR(+) = :y
                 AND DECODE ( :plan_month, 0, mk.MONTH, :plan_month) = mk.MONTH
                 AND m.id_net(+) = :net
                 AND m.plan_type(+) = :plan_type
                 AND mk.MONTH = m.MONTH(+)
                 AND y.YEAR(+) = :y
                 AND y.plan_type(+) = :plan_type
                 AND y.id_net(+) = :net
                 AND m.statya = s.id(+)
        GROUP BY mk.month_name,
                 mk.MONTH,
                 mk.koeff,
                 y.sales,
                 mk.koeff_ng,
                 y.sales_ng,
                 mk.koeff_coffee,
                 y.sales_coffee
        ORDER BY mk.MONTH)