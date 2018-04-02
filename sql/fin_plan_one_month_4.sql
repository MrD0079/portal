/* Formatted on 26.03.2018 18:56:15 (QP5 v5.252.13127.32867) */
SELECT SUM (plan) + SUM (plan_ng) + SUM (plan_coffee) plan_all,
       SUM (plan) plan,
       SUM (plan_ng) plan_ng,
       SUM (plan_coffee) plan_coffee,
       (SUM (fakt) + SUM (fakt_ng) + SUM (fakt_coffee)) / 1000 fakt_all,
       SUM (fakt) fakt,
       SUM (fakt_ng) fakt_ng,
       SUM (fakt_coffee) fakt_coffee,
       SUM (zatr) + SUM (zatr_ng) + SUM (zatr_coffee) zatr_all,
       SUM (zatr) zatr,
       SUM (zatr_ng) zatr_ng,
       SUM (zatr_coffee) zatr_coffee,
         (DECODE (
             (SUM (fakt) + SUM (fakt_ng) + SUM (fakt_coffee)),
             0, 0,
               (SUM (zatr) + SUM (zatr_ng) + SUM (zatr_coffee))
             / (SUM (fakt) + SUM (fakt_ng) + SUM (fakt_coffee))
             * 100))
       * 1000
          perc_zatr_all,
       DECODE (SUM (fakt), 0, 0, SUM (zatr) / SUM (fakt) * 100) perc_zatr,
       DECODE (SUM (fakt_ng), 0, 0, SUM (zatr_ng) / SUM (fakt_ng) * 100)
          perc_zatr_ng,
       DECODE (SUM (fakt_coffee),
               0, 0,
               SUM (zatr_coffee) / SUM (fakt_coffee) * 100)
          perc_zatr_coffee
  FROM (  SELECT NVL (
                    SUM (
                       CASE WHEN s.parent NOT IN (42, 96882041) THEN m.total END),
                    0)
                    zatr,
                 NVL (SUM (CASE WHEN s.parent = 42 THEN m.total END), 0) zatr_ng,
                 NVL (SUM (CASE WHEN s.parent = 96882041 THEN m.total END), 0)
                    zatr_coffee,
                 pf.plan,
                 pf.fakt,
                 pf.plan_ng,
                 pf.fakt_ng,
                 pf.plan_coffee,
                 pf.fakt_coffee
            FROM nets_plan_month m,
                 month_koeff mk,
                 statya s,
                 (SELECT year,
                         month,
                         nets.id_net,
                         plan,
                         fakt,
                         plan_ng,
                         fakt_ng,
                         plan_coffee,
                         fakt_coffee
                    FROM networkplanfact, nets
                   WHERE nets.sw_kod = networkplanfact.id_net) pf
           WHERE     m.YEAR(+) = :y
                 AND DECODE ( :plan_month, 0, mk.MONTH, :plan_month) = mk.MONTH
                 AND m.id_net(+) = :net
                 AND m.plan_type(+) = :plan_type
                 AND mk.MONTH = m.MONTH(+)
                 AND m.statya = s.id(+)
                 AND pf.YEAR(+) = :y
                 AND pf.month(+) = mk.MONTH
                 AND pf.id_net(+) = :net
        GROUP BY mk.month_name,
                 mk.koeff,
                 mk.MONTH,
                 pf.plan,
                 pf.fakt,
                 pf.plan_ng,
                 pf.fakt_ng,
                 pf.plan_coffee,
                 pf.fakt_coffee
        ORDER BY mk.MONTH)