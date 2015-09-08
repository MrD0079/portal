/* Formatted on 17/06/2015 13:00:31 (QP5 v5.227.12220.39724) */
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
         (SELECT COUNT (*)
            FROM invoice_detail
           WHERE statya = m.ID AND invoice = :invoice)
            linked2invoice,
           NVL (m.total, 0)
         - NVL ( (SELECT SUM (summa)
                    FROM invoice_detail
                   WHERE statya = m.ID),
                0)
            nocover,
         (SELECT summa
            FROM invoice_detail
           WHERE statya = m.ID AND invoice = :invoice)
            invoice_summa
    FROM nets_plan_month m,
         statya s,
         statya gr,
         payment_format pf,
         payment_type pt,
         month_koeff mk,
         nets n
   WHERE     m.id_net = n.id_net
         AND m.id_net = :net
         AND m.plan_type = :plan_type
         AND s.ID(+) = m.statya
         AND gr.ID(+) = s.PARENT
         AND pf.ID(+) = m.payment_format
         AND pt.ID(+) = m.payment_type
         AND mk.MONTH = m.MONTH
         AND TO_DATE ('01' || '.' || m.MONTH || '.' || m.YEAR, 'dd.mm.yy') BETWEEN TO_DATE (
                                                                                      :sd,
                                                                                      'dd.mm.yyyy')
                                                                               AND TO_DATE (
                                                                                      :ed,
                                                                                      'dd.mm.yyyy')
         AND (:tn IN (DECODE ( (SELECT pos_id
                                  FROM spdtree
                                 WHERE svideninn = :tn),
                              24, n.tn_mkk,
                              34, n.tn_rmkk,
                              63, :tn,
                              65, :tn,
                              67, :tn,
                              (SELECT pos_id
                                 FROM user_list
                                WHERE tn = :tn AND is_super = 1), :tn)))
         AND m.payment_type IN (1, 3)
ORDER BY mk.MONTH,
         groupp,
         statya,
         descript