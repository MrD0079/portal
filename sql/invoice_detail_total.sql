/* Formatted on 11.01.2013 13:16:03 (QP5 v5.163.1008.3004) */
SELECT SUM (m.cnt) cnt,
       SUM (m.bonus) bonus,
       SUM (m.total) total,
       SUM (NVL (m.total, 0)
            - NVL ( (SELECT SUM (summa)
                       FROM invoice_detail
                      WHERE statya = m.ID),
                   0))
          nocover,
       SUM ( (SELECT summa
                FROM invoice_detail
               WHERE statya = m.ID AND invoice = :invoice))
          invoice_summa,
       SUM (NVL ( (SELECT summa
                     FROM invoice_detail
                    WHERE statya = m.id AND invoice = :invoice),
                   NVL (m.total, 0)
                 - NVL ( (SELECT SUM (summa)
                            FROM invoice_detail
                           WHERE statya = m.id),
                        0)))
          cover
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
       AND TO_DATE ('01' || '.' || m.MONTH || '.' || m.YEAR, 'dd.mm.yy') BETWEEN TO_DATE (:sd, 'dd.mm.yyyy') AND TO_DATE (:ed, 'dd.mm.yyyy')
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
       AND m.payment_type NOT IN (1, 3)