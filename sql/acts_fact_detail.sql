/* Formatted on 17/06/2015 13:00:14 (QP5 v5.227.12220.39724) */
  SELECT m.ID rid,
         m.YEAR,
         mk.month_name,
         pf.pay_format,
         gr.cost_item groupp,
         s.cost_item statya,
         m.descript,
         pt.pay_type,
         m.cnt,
         m.price,
         m.bonus,
         m.total,
         m.mkk_ter,
         fn_getname (m.mkk_ter) mkk_name,
         ind.summa
    FROM nets_plan_month m,
         statya s,
         statya gr,
         payment_format pf,
         payment_type pt,
         month_koeff mk,
         nets n,
         invoice_detail ind
   WHERE     m.id_net = n.id_net
         AND ind.invoice = :invoice
         AND IND.STATYA = m.id
         AND s.ID(+) = m.statya
         AND gr.ID(+) = s.PARENT
         AND pf.ID(+) = m.payment_format
         AND pt.ID(+) = m.payment_type
         AND mk.MONTH = m.MONTH
         AND m.payment_type NOT IN (1, 3)
ORDER BY mk.MONTH,
         groupp,
         statya,
         descript