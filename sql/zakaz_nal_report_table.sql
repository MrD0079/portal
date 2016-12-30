/* Formatted on 30.12.2016 13:22:39 (QP5 v5.252.13127.32867) */
  SELECT m.rmkk,
         fn_getname (m.rmkk) rmkk_name,
         CASE WHEN n.tn_mkk <> m.mkk_ter THEN 1 ELSE 0 END mkk_diff,
         m.mkk_ter,
         fn_getname (m.mkk_ter) mkk_name,
         n.id_net,
         n.net_name,
         m.total1,
         TO_CHAR (pnm.lu, 'dd.mm.yyyy hh24:mi:ss') nm_lu,
         pnm.ok nm_ok,
         tm_prev.sum_per tm_prev_sum_per,
         tm_prev.income_sum tm_prev_income_sum,
         ptm.recipient,
         ptm.sum_per,
         ptm.income_sum,
         ptm.comm,
         uptm.fio recipient_fio,
         NVL (fu_prev.total, 0) fu_prev_total,
         fou.total fou_total,
         faktokazusl.total faktokazusl_total
    FROM (  SELECT (SELECT tn_rmkk
                      FROM nets
                     WHERE tn_mkk = m1.mkk_ter AND ROWNUM = 1)
                      rmkk,
                   m1.mkk_ter,
                   m1.year,
                   m1.month,
                   m1.id_net,
                   SUM (CASE WHEN m1.payment_type = 1 THEN m1.total END) total1
              FROM nets_plan_month m1
             WHERE m1.payment_type = 1 AND m1.plan_type = 3
          GROUP BY m1.mkk_ter,
                   m1.year,
                   m1.month,
                   m1.id_net) m,
         nets n,
         promo_nm pnm,
         (  SELECT tn, SUM (income_sum) income_sum, SUM (sum_per) sum_per
              FROM promo_tm
             WHERE TO_DATE ('1.' || month || '.' || year, 'dd.mm.yyyy') <=
                      TO_DATE ('1.' || :plan_month || '.' || :y, 'dd.mm.yyyy')
          GROUP BY tn) tm_prev,
         (SELECT *
            FROM promo_tm
           WHERE month = :plan_month AND year = :y) ptm,
         user_list uptm,
         (  SELECT m.mkk_ter, SUM (id.summa                        /*m.total*/
                                           ) total
              FROM nets_plan_month m, invoice_detail id, invoice i
             WHERE     id.statya = m.id
                   AND m.plan_type = 4
                   AND m.payment_type = 1
                   AND i.id = id.invoice
                   AND i.oplachen = 1
                   AND TO_DATE ('1.' || m.month || '.' || m.year, 'dd.mm.yyyy') <
                          TO_DATE ('1.' || :plan_month || '.' || :y,
                                   'dd.mm.yyyy')
          GROUP BY m.mkk_ter) fu_prev,
         (  SELECT m.mkk_ter, m.id_net, SUM (id.summa              /*m.total*/
                                                     ) total
              FROM nets_plan_month m,
                   invoice_detail id,
                   invoice i,
                   nets_plan_month ms,
                   calendar c
             WHERE     m.id = id.statya
                   AND m.plan_type = 4
                   /*AND m.YEAR = :y*/
                   AND m.payment_type = 1
                   /*AND m.MONTH = :plan_month*/
                   AND i.id = id.invoice
                   AND i.oplachen = 1
                   AND ms.id = id.statya
                   AND i.oplata_date = c.data
                   AND c.y = :y
                   AND c.my = :plan_month
          GROUP BY m.mkk_ter, m.id_net) fou,
         (  SELECT m.mkk_ter, m.id_net, SUM (m.total) total
              FROM nets_plan_month m
             WHERE     m.plan_type = 4
                   AND m.payment_type = 1
                   AND m.year = :y
                   AND m.month = :plan_month
          GROUP BY m.mkk_ter, m.id_net) faktokazusl
   WHERE     m.id_net = n.id_net
         AND m.mkk_ter = fu_prev.mkk_ter(+)
         AND m.id_net = fou.id_net(+)
         AND m.mkk_ter = fou.mkk_ter(+)
         AND m.id_net = faktokazusl.id_net(+)
         AND m.mkk_ter = faktokazusl.mkk_ter(+)
         AND m.YEAR = :y
         AND DECODE ( :nets, 0, m.id_net, :nets) = m.id_net
         AND :plan_month = m.MONTH
         AND (   (    m.mkk_ter IN (SELECT slave
                                      FROM full
                                     WHERE master = :tn)
                  AND DECODE ( :tn_rmkk, 0, m.rmkk, :tn_rmkk) = m.rmkk
                  AND DECODE ( :tn_mkk, 0, m.mkk_ter, :tn_mkk) = m.mkk_ter)
              OR (    :tn IN (DECODE ( (SELECT pos_id
                                          FROM spdtree
                                         WHERE svideninn = :tn),
                                      24, n.tn_mkk,
                                      34, n.tn_rmkk,
                                      63, :tn,
                                      65, :tn,
                                      67, :tn,
                                      (SELECT pos_id
                                         FROM user_list
                                        WHERE tn = :tn AND is_super = 1), :tn))
                  AND DECODE ( :tn_rmkk, 0, m.rmkk, :tn_rmkk) = m.rmkk
                  AND DECODE ( :tn_mkk, 0, m.mkk_ter, :tn_mkk) = m.mkk_ter))
         AND :y = pnm.year(+)
         AND :plan_month = pnm.month(+)
         AND m.rmkk = pnm.tn(+)
         AND m.mkk_ter = tm_prev.tn(+)
         AND m.mkk_ter = ptm.tn(+)
         AND ptm.recipient = uptm.tn(+)
ORDER BY rmkk_name, mkk_name, n.net_name