/* Formatted on 20.01.2017 16:16:31 (QP5 v5.252.13127.32867) */
  SELECT rmkk,
         rmkk_name,
         oknm_nm,
         oknm_fm,
         oknm_nmlu,
         oknm_fmlu,
         SUM (tm_prev_sum_per) tm_prev_sum_per,
         SUM (sum_per) sum_per,
         SUM (total1) total1,
         SUM (faktoplachusl_total) faktoplachusl_total,
         SUM (faktokazusl_total) faktokazusl_total,
         SUM (remain) remain,
         SUM (remain_prev) remain_prev
    FROM (  SELECT rmkk,
                   rmkk_name,
                   mkk_ter,
                   mkk_name,
                   MAX (mkk_diff) mkk_diff,
                   oknm_nm,
                   oknm_fm,
                   oknm_nmlu,
                   oknm_fmlu,
                   ok_tm,
                   ok_nm,
                   ok_fm,
                   ok_tm_lu,
                   ok_nm_lu,
                   ok_fm_lu,
                   recipient,
                   comm,
                   tm_prev_sum_per,
                   sum_per,
                   recipient_fio,
                   SUM (total1) total1,
                   SUM (faktoplachusl_total) faktoplachusl_total,
                   faktoplachusl_cur_total,
                   faktoplachusl_prev_total,
                   SUM (faktokazusl_total) faktokazusl_total,
                     NVL (tm_prev_sum_per, 0)
                   - NVL (faktoplachusl_prev_total, 0)
                   + NVL (sum_per, 0)
                   - NVL (faktoplachusl_cur_total, 0)
                      remain,
                   NVL (tm_prev_sum_per, 0) - NVL (faktoplachusl_prev_total, 0)
                      remain_prev
              FROM (  SELECT rmkk,
                             rmkk_name,
                             mkk_ter,
                             mkk_name,
                             MAX (mkk_diff) mkk_diff,
                             oknm_nm,
                             oknm_fm,
                             oknm_nmlu,
                             oknm_fmlu,
                             ok_tm,
                             ok_nm,
                             ok_fm,
                             ok_tm_lu,
                             ok_nm_lu,
                             ok_fm_lu,
                             id_net,
                             net_name,
                             recipient,
                             tm_prev_sum_per,
                             sum_per,
                             comm,
                             recipient_fio,
                             SUM (total1) total1,
                             SUM (faktoplachusl_total) faktoplachusl_total,
                             faktoplachusl_cur_total,
                             faktoplachusl_prev_total,
                             SUM (faktokazusl_total) faktokazusl_total
                        FROM (
                        SELECT m.rmkk,
                                       m.rmkk_name,
                                       m.mkk_diff,
                                       m.mkk_ter,
                                       m.mkk_name,
                                       m.id_net,
                                       m.net_name,
                                       m.total1,
                                       tm_prev.sum_per tm_prev_sum_per,
                                       fn_getname (ptm.recipient) recipient_fio,
                                       ptm.recipient,
                                       ptm.sum_per,
                                       ptm.comm,
                                       ptm.ok_tm,
                                       ptm.ok_nm,
                                       ptm.ok_fm,
                                       TO_CHAR (ptm.ok_tm_lu,
                                                'dd.mm.yyyy hh24:mi:ss')
                                          ok_tm_lu,
                                       TO_CHAR (ptm.ok_nm_lu,
                                                'dd.mm.yyyy hh24:mi:ss')
                                          ok_nm_lu,
                                       TO_CHAR (ptm.ok_fm_lu,
                                                'dd.mm.yyyy hh24:mi:ss')
                                          ok_fm_lu,
                                       pnm.oknm_nm,
                                       pnm.oknm_fm,
                                       TO_CHAR (pnm.oknm_nmlu,
                                                'dd.mm.yyyy hh24:mi:ss')
                                          oknm_nmlu,
                                       TO_CHAR (pnm.oknm_fmlu,
                                                'dd.mm.yyyy hh24:mi:ss')
                                          oknm_fmlu,
                                       faktoplachusl.total faktoplachusl_total,
                                       faktoplachusl_cur.total
                                          faktoplachusl_cur_total,
                                       faktoplachusl_prev.total
                                          faktoplachusl_prev_total,
                                       faktokazusl.total faktokazusl_total
                                  FROM (  SELECT fn_getname (n2.tn_rmkk) rmkk_name,
                                                 n2.tn_rmkk rmkk,
                                                 fn_getname (list.mkk_ter) mkk_name,
                                                 list.mkk_ter,
                                                 n2.net_name,
                                                 MAX (
                                                    CASE
                                                       WHEN n2.tn_mkk <> list.mkk_ter
                                                       THEN
                                                          1
                                                       ELSE
                                                          0
                                                    END)
                                                    mkk_diff,
                                                 list.year,
                                                 list.month,
                                                 list.id_net,
                                                 SUM (
                                                    CASE
                                                       WHEN m1.payment_type = 1
                                                       THEN
                                                          m1.total
                                                    END)
                                                    total1
                                            FROM (SELECT DISTINCT id_net,
                                                                  year,
                                                                  month,
                                                                  mkk_ter
                                                    FROM nets_plan_month
                                                   WHERE     plan_type = 3
                                                         AND payment_type = 1
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
                                                 (SELECT DISTINCT tn_rmkk, tn_mkk
                                                    FROM nets) n1,
                                                 nets n2
                                           WHERE     list.id_net = m1.id_net(+)
                                                 AND list.year = m1.year(+)
                                                 AND list.month = m1.month(+)
                                                 AND list.mkk_ter = m1.mkk_ter(+)
                                                 AND m1.payment_type(+) = 1
                                                 AND m1.plan_type(+) = 3
                                                 AND n1.tn_mkk = list.mkk_ter
                                                 AND list.id_net = n2.id_net
                                                 /*AND DECODE ( :nets, 0, list.id_net, :nets) =
                                                        list.id_net*/
                                                 AND (    (   list.mkk_ter IN (SELECT slave
                                                                                 FROM full
                                                                                WHERE master =
                                                                                         :tn)
                                                           OR (SELECT is_fin_man
                                                                 FROM user_list
                                                                WHERE tn = :tn) = 1)
                                                      AND DECODE ( :tn_rmkk,
                                                                  0, n2.tn_rmkk,
                                                                  :tn_rmkk) =
                                                             n2.tn_rmkk
                                                      AND DECODE ( :tn_mkk,
                                                                  0, list.mkk_ter,
                                                                  :tn_mkk) =
                                                             list.mkk_ter)
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
                                                       '1.' || :plan_month || '.' || :y,
                                                       'dd.mm.yyyy')
                                        GROUP BY tn) tm_prev,
                                       (SELECT *
                                          FROM promo_tm
                                         WHERE month = :plan_month AND year = :y) ptm,
                                       (  SELECT m.mkk_ter,
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
                                                 /*AND DECODE ( :nets, 0, m.id_net, :nets) =
                                                        m.id_net*/
                                                 AND c.y = :y
                                                 AND c.my = :plan_month
                                        GROUP BY m.mkk_ter, m.id_net) faktoplachusl,
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
                                                 /*AND DECODE ( :nets, 0, m.id_net, :nets) =
                                                        m.id_net*/
                                                 AND c.y = :y
                                                 AND c.my = :plan_month
                                        GROUP BY m.mkk_ter) faktoplachusl_cur,
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
                                                 /*AND DECODE ( :nets, 0, m.id_net, :nets) =
                                                        m.id_net*/
                                                 AND c.data <
                                                        TO_DATE (
                                                              '1.'
                                                           || :plan_month
                                                           || '.'
                                                           || :y,
                                                           'dd.mm.yyyy')
                                                  /* [fix] Старт учета с 1 мая 2019 в связи изменением  привязкой МКК - Сеть */
                                                 AND TO_DATE ('01.'|| i.m || '.'|| i.y,'dd.mm.yyyy') >= TO_DATE ('01.05.2019','dd.mm.yyyy')
                                        GROUP BY m.mkk_ter) faktoplachusl_prev,
                                       (  SELECT m.mkk_ter,
                                                 m.id_net,
                                                 SUM (m.total) total
                                            FROM nets_plan_month m
                                           WHERE     m.plan_type = 4
                                                 AND m.payment_type = 1 /*AND DECODE ( :nets, 0, m.id_net, :nets) =
                                                                               m.id_net*/
                                                 AND m.year = :y
                                                 AND m.month = :plan_month
                                        GROUP BY m.mkk_ter, m.id_net) faktokazusl,
                                       (SELECT *
                                          FROM promo_nm
                                         WHERE :y = year AND :plan_month = month) pnm
                                 WHERE     m.id_net = faktoplachusl.id_net(+)
                                       AND m.mkk_ter = faktoplachusl.mkk_ter(+)
                                       AND m.mkk_ter = faktoplachusl_cur.mkk_ter(+)
                                       AND m.mkk_ter = faktoplachusl_prev.mkk_ter(+)
                                       AND m.id_net = faktokazusl.id_net(+)
                                       AND m.mkk_ter = faktokazusl.mkk_ter(+)
                                       AND m.YEAR = :y
                                       AND m.MONTH = :plan_month
                                       AND m.mkk_ter = tm_prev.tn(+)
                                       AND m.mkk_ter = ptm.tn(+)
                                       AND m.rmkk = pnm.tn(+)
                              ORDER BY rmkk_name, mkk_name, net_name)
                    GROUP BY rmkk,
                             rmkk_name,
                             mkk_ter,
                             mkk_name,
                             oknm_nm,
                             oknm_fm,
                             oknm_nmlu,
                             oknm_fmlu,
                             ok_tm,
                             ok_nm,
                             ok_fm,
                             ok_tm_lu,
                             ok_nm_lu,
                             ok_fm_lu,
                             id_net,
                             net_name,
                             recipient,
                             tm_prev_sum_per,
                             sum_per,
                             comm,
                             recipient_fio,
                             faktoplachusl_cur_total,
                             faktoplachusl_prev_total
                    ORDER BY rmkk_name, mkk_name, net_name)
          GROUP BY rmkk,
                   rmkk_name,
                   mkk_ter,
                   mkk_name,
                   oknm_nm,
                   oknm_fm,
                   oknm_nmlu,
                   oknm_fmlu,
                   ok_tm,
                   ok_nm,
                   ok_fm,
                   ok_tm_lu,
                   ok_nm_lu,
                   ok_fm_lu,
                   recipient,
                   tm_prev_sum_per,
                   sum_per,
                   comm,
                   recipient_fio,
                   faktoplachusl_cur_total,
                   faktoplachusl_prev_total
          ORDER BY rmkk_name, mkk_name)
GROUP BY rmkk,
         rmkk_name,
         oknm_nm,
         oknm_fm,
         oknm_nmlu,
         oknm_fmlu
ORDER BY rmkk_name