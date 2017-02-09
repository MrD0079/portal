/* Formatted on 09.02.2017 14:59:06 (QP5 v5.252.13127.32867) */
  SELECT rmkk,
         rmkk_name,
         mkk_ter,
         mkk_name,
         MAX (mkk_diff) mkk_diff,
         id_net,
         net_name,
         SUM (total1) total1,
         SUM (faktoplachusl_total) faktoplachusl_total,
         SUM (faktokazusl_total) faktokazusl_total
    FROM (  SELECT y,
                   my,
                   rmkk,
                   rmkk_name,
                   mkk_ter,
                   mkk_name,
                   MAX (mkk_diff) mkk_diff,
                   id_net,
                   net_name,
                   SUM (total1) total1,
                   SUM (faktoplachusl_total) faktoplachusl_total,
                   SUM (faktokazusl_total) faktokazusl_total
              FROM (  SELECT c.y,
                             c.my,
                             m.rmkk,
                             m.rmkk_name,
                             m.mkk_diff,
                             m.mkk_ter,
                             m.mkk_name,
                             m.id_net,
                             m.net_name,
                             m.total1,
                             tm_prev.sum_per tm_prev_sum_per,
                             ptm.sum_per,
                             faktoplachusl.total faktoplachusl_total,
                             faktoplachusl_cur.total faktoplachusl_cur_total,
                             faktoplachusl_prev.total faktoplachusl_prev_total,
                             faktokazusl.total faktokazusl_total
                        FROM (  SELECT data,
                                       y,
                                       my,
                                       mt
                                  FROM calendar
                                 WHERE     data = TRUNC (data, 'mm')
                                       /*AND y = :y
                                       AND my BETWEEN DECODE ( :byyear, 1, 1, :plan_month)
                                                  AND :plan_month*/

                                       AND TRUNC (data, 'mm') BETWEEN TO_DATE (
                                                                            '1.'
                                                                         || DECODE (
                                                                               :byyear,
                                                                               1, 1,
                                                                               :plan_month)
                                                                         || '.'
                                                                         || :y,
                                                                         'dd.mm.yyyy')
                                                                  AND TO_DATE (
                                                                            '1.'
                                                                         || :plan_month
                                                                         || '.'
                                                                         || :y,
                                                                         'dd.mm.yyyy')
                              ORDER BY data) c,
                             (  SELECT fn_getname (n2.tn_rmkk) rmkk_name,
                                       n2.tn_rmkk rmkk,
                                       fn_getname (list.mkk_ter) mkk_name,
                                       list.mkk_ter,
                                       n2.net_name,
                                       MAX (
                                          CASE
                                             WHEN n2.tn_mkk <> list.mkk_ter THEN 1
                                             ELSE 0
                                          END)
                                          mkk_diff,
                                       list.year,
                                       list.month,
                                       list.id_net,
                                       SUM (
                                          CASE
                                             WHEN m1.payment_type = 1 THEN m1.total
                                          END)
                                          total1
                                  FROM (SELECT DISTINCT id_net,
                                                        year,
                                                        month,
                                                        mkk_ter
                                          FROM nets_plan_month
                                         WHERE plan_type = 3 AND payment_type = 1
                                        UNION
                                        SELECT m.id_net,
                                               c.y,
                                               c.my,
                                               m.mkk_ter
                                          FROM nets_plan_month m,
                                               invoice_detail id,
                                               invoice i,
                                               nets_plan_month ms,
                                               calendar c,
                                               nets n
                                         WHERE     m.id = id.statya
                                               AND m.plan_type = 4
                                               AND m.payment_type = 1
                                               AND i.id = id.invoice
                                               AND i.oplachen = 1
                                               AND ms.id = id.statya
                                               AND i.oplata_date = c.data
                                               AND m.id_net = n.id_net) list,
                                       nets_plan_month m1,
                                       (SELECT DISTINCT tn_rmkk, tn_mkk FROM nets) n1,
                                       nets n2
                                 WHERE     list.id_net = m1.id_net(+)
                                       AND list.year = m1.year(+)
                                       AND list.month = m1.month(+)
                                       AND list.mkk_ter = m1.mkk_ter(+)
                                       AND m1.payment_type(+) = 1
                                       AND m1.plan_type(+) = 3
                                       AND n1.tn_mkk = list.mkk_ter
                                       AND list.id_net = n2.id_net
                                       AND (    (   list.mkk_ter IN (SELECT slave
                                                                       FROM full
                                                                      WHERE master =
                                                                               :tn)
                                                 OR (SELECT is_fin_man
                                                       FROM user_list
                                                      WHERE tn = :tn) = 1)
                                            AND DECODE ( :tn_rmkk,
                                                        0, n2.tn_rmkk,
                                                        :tn_rmkk) = n2.tn_rmkk
                                            AND DECODE ( :tn_mkk,
                                                        0, list.mkk_ter,
                                                        :tn_mkk) = list.mkk_ter)
                              GROUP BY n2.tn_rmkk,
                                       list.mkk_ter,
                                       n2.net_name,
                                       list.year,
                                       list.month,
                                       list.id_net) m,
                             (  SELECT tn, SUM (sum_per) sum_per
                                  FROM promo_tm
                                 WHERE TO_DATE ('1.' || month || '.' || year,
                                                'dd.mm.yyyy') <
                                          TO_DATE (
                                                '1.'
                                             || DECODE ( :byyear, 1, 1, :plan_month)
                                             || '.'
                                             || :y,
                                             'dd.mm.yyyy')
                              GROUP BY tn) tm_prev,
                             promo_tm ptm,
                             (  SELECT c.y,
                                       c.my,
                                       m.mkk_ter,
                                       m.id_net,
                                       SUM (id.summa) total
                                  FROM nets_plan_month m,
                                       invoice_detail id,
                                       invoice i,
                                       nets_plan_month ms,
                                       calendar c
                                 WHERE     m.id = id.statya
                                       AND m.plan_type = 4
                                       AND m.payment_type = 1
                                       AND i.id = id.invoice
                                       AND i.oplachen = 1
                                       AND ms.id = id.statya
                                       AND i.oplata_date = c.data
                              GROUP BY c.y,
                                       c.my,
                                       m.mkk_ter,
                                       m.id_net) faktoplachusl,
                             (  SELECT c.y,
                                       c.my,
                                       m.mkk_ter,
                                       SUM (id.summa) total
                                  FROM nets_plan_month m,
                                       invoice_detail id,
                                       invoice i,
                                       nets_plan_month ms,
                                       calendar c
                                 WHERE     m.id = id.statya
                                       AND m.plan_type = 4
                                       AND m.payment_type = 1
                                       AND i.id = id.invoice
                                       AND i.oplachen = 1
                                       AND ms.id = id.statya
                                       AND i.oplata_date = c.data
                              GROUP BY c.y, c.my, m.mkk_ter) faktoplachusl_cur,
                             (  SELECT m.mkk_ter, SUM (id.summa) total
                                  FROM nets_plan_month m,
                                       invoice_detail id,
                                       invoice i,
                                       nets_plan_month ms,
                                       calendar c
                                 WHERE     m.id = id.statya
                                       AND m.plan_type = 4
                                       AND m.payment_type = 1
                                       AND i.id = id.invoice
                                       AND i.oplachen = 1
                                       AND ms.id = id.statya
                                       AND i.oplata_date = c.data
                                       AND c.data <
                                              TO_DATE (
                                                    '1.'
                                                 || DECODE ( :byyear,
                                                            1, 1,
                                                            :plan_month)
                                                 || '.'
                                                 || :y,
                                                 'dd.mm.yyyy')
                              GROUP BY m.mkk_ter) faktoplachusl_prev,
                             (  SELECT m.year,
                                       m.month,
                                       m.mkk_ter,
                                       m.id_net,
                                       SUM (m.total) total
                                  FROM nets_plan_month m
                                 WHERE m.plan_type = 4 AND m.payment_type = 1
                              GROUP BY m.year,
                                       m.month,
                                       m.mkk_ter,
                                       m.id_net) faktokazusl,
                             promo_nm pnm
                       WHERE     m.id_net = faktoplachusl.id_net(+)
                             AND m.mkk_ter = faktoplachusl.mkk_ter(+)
                             AND m.year = faktoplachusl.y(+)
                             AND m.month = faktoplachusl.my(+)
                             AND m.mkk_ter = faktoplachusl_cur.mkk_ter(+)
                             AND m.year = faktoplachusl_cur.y(+)
                             AND m.month = faktoplachusl_cur.my(+)
                             AND m.mkk_ter = faktoplachusl_prev.mkk_ter(+)
                             AND m.id_net = faktokazusl.id_net(+)
                             AND m.mkk_ter = faktokazusl.mkk_ter(+)
                             AND m.year = faktokazusl.year(+)
                             AND m.month = faktokazusl.month(+)
                             AND m.mkk_ter = tm_prev.tn(+)
                             AND m.mkk_ter = ptm.tn(+)
                             AND m.year = ptm.year(+)
                             AND m.month = ptm.month(+)
                             AND m.rmkk = pnm.tn(+)
                             AND m.year = pnm.year(+)
                             AND m.month = pnm.month(+)
                             AND c.y = m.year
                             AND c.my = m.month
                    ORDER BY c.y,
                             c.my,
                             rmkk_name,
                             mkk_name,
                             net_name)
          GROUP BY y,
                   my,
                   rmkk,
                   rmkk_name,
                   mkk_ter,
                   mkk_name,
                   id_net,
                   net_name,
                   sum_per
          ORDER BY y,
                   my,
                   rmkk_name,
                   mkk_name,
                   net_name)
GROUP BY rmkk,
         rmkk_name,
         mkk_ter,
         mkk_name,
         id_net,
         net_name
ORDER BY rmkk_name, mkk_name, net_name