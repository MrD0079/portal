/* Formatted on 12/8/2015 1:38:28  (QP5 v5.252.13127.32867) */
  SELECT NVL (SUM (CASE WHEN s.parent NOT IN (42, 96882041) THEN m.total END),
              0)
            zatr,
         NVL (SUM (CASE WHEN s.parent = 42 THEN m.total END), 0) zatr_ng,
         NVL (SUM (CASE WHEN s.parent = 96882041 THEN m.total END), 0)
            zatr_coffee,
         DECODE (
            NVL (y.sales, 0),
            0, 0,
              SUM (CASE WHEN s.parent NOT IN (42, 96882041) THEN m.total END)
            / y.sales
            * 100)
            perc_zatr,
         DECODE (
            NVL (y.sales_ng, 0),
            0, 0,
            SUM (CASE WHEN s.parent = 42 THEN m.total END) / y.sales_ng * 100)
            perc_zatr_ng,
         DECODE (
            NVL (y.sales_coffee, 0),
            0, 0,
              SUM (CASE WHEN s.parent = 96882041 THEN m.total END)
            / y.sales_coffee
            * 100)
            perc_zatr_coffee
    FROM nets_plan_month m,
         nets_plan_year y,
         statya s,
         statya gr,
         payment_format pf,
         payment_type pt,
         month_koeff mk,
         nets n,
         bud_fil f
   WHERE     m.payer = f.id(+)
         AND m.id_net = n.id_net
         AND m.YEAR = :y
         AND m.id_net = :net
         AND m.plan_type = :plan_type
         AND m.YEAR = y.year(+)
         AND m.id_net = y.id_net(+)
         AND m.plan_type = y.plan_type(+)
         AND s.ID(+) = m.statya
         AND gr.ID(+) = s.PARENT
         AND pf.ID(+) = m.payment_format
         AND pt.ID(+) = m.payment_type
         AND mk.MONTH = m.MONTH
         AND DECODE ( :plan_month, 0, m.MONTH, :plan_month) = m.MONTH
         AND (   :tn IN (DECODE (
                            (SELECT pos_id
                               FROM spdtree
                              WHERE svideninn = :tn),
                            24, m.mkk_ter,
                            34, (SELECT DISTINCT tn_rmkk
                                   FROM nets
                                  WHERE tn_mkk = m.mkk_ter),
                            181976662, (SELECT DISTINCT tn_rmkk
                                    FROM nets
                                    WHERE tn_mkk = m.mkk_ter), /* Cherkasski */
                            63, :tn,
                            65, :tn,
                            67, :tn,
                            (SELECT pos_id
                               FROM user_list
                              WHERE tn = :tn AND (is_super = 1 OR is_admin = 1)), :tn))
              OR :tn = m.mkk_ter
              OR :tn IN (SELECT tn_rmkk
                           FROM nets
                          WHERE tn_mkk = m.mkk_ter))
GROUP BY y.sales, y.sales_ng, y.sales_coffee