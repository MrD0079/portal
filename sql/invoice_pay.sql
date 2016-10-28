/* Formatted on 20/04/2016 11:37:38 (QP5 v5.252.13127.32867) */
  SELECT i.*,
         n.net_name,
         fn_getname (n.tn_mkk) mkk,
         fn_getname (n.tn_rmkk) rmkk,
         TO_CHAR (i.DATA, 'dd.mm.yyyy') data_t,
         TO_CHAR (i.act_dt, 'dd.mm.yyyy') act_dt_t,
         TO_CHAR (i.lu, 'dd.mm.yyyy hh24:mi:ss') lu_t,
         TO_CHAR (i.invoice_sended_lu, 'dd.mm.yyyy hh24:mi:ss')
            invoice_sended_lu_t,
         TO_CHAR (i.oplata_date, 'dd.mm.yyyy') oplata_date,
         TO_CHAR (i.act_prov_month, 'dd.mm.yyyy') act_prov_month,
         (SELECT COUNT (*)
            FROM invoice_detail
           WHERE invoice = i.ID)
            st_count,
         (SELECT NVL (SUM (summa), 0)
            FROM invoice_detail
           WHERE invoice = i.ID)
            st_total,
         p.name payer_name,
         u.name urlic_name,
         (SELECT SUM (CASE
                         WHEN   NVL (m.total, 0)
                              - NVL ( (SELECT SUM (summa)
                                         FROM invoice_detail
                                        WHERE statya = m.ID),
                                     0) < -0.1
                         THEN
                            1
                      END)
            FROM nets_plan_month m, invoice_detail ind
           WHERE     ind.invoice = i.id
                 AND IND.STATYA = m.id
                 AND m.payment_type NOT IN (1, 3))
            nocover_cnt
    FROM invoice i,
         nets n,
         bud_fil p,
         urlic u
   WHERE     n.id_net = i.id_net
         AND i.payer = p.id
         AND DECODE ( :payer, 0, i.payer, :payer) = i.payer
         AND u.id(+) = i.urlic
         AND :tn IN (DECODE (
                        (SELECT pos_id
                           FROM spdtree
                          WHERE svideninn = :tn),
                        24, n.tn_mkk,
                        34, n.tn_rmkk,
                        63, :tn,
                        65, :tn,
                        67, :tn,
                        (SELECT pos_id
                           FROM user_list
                          WHERE     tn = :tn
                                AND (   is_super = 1
                                     OR is_fin_man = 1
                                     OR is_admin = 1)), :tn))
         AND DECODE ( :tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
         AND DECODE ( :tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
         AND DECODE ( :nets, 0, n.id_net, :nets) = n.id_net
         AND TO_DATE ('01' || '.' || i.m || '.' || i.y, 'dd.mm.yy') BETWEEN TO_DATE (
                                                                               :sd,
                                                                               'dd.mm.yyyy')
                                                                        AND TO_DATE (
                                                                               :ed,
                                                                               'dd.mm.yyyy')
         AND NVL (i.act_prov_month, TRUNC (SYSDATE, 'mm')) BETWEEN DECODE (
                                                                      :act_prov_month_s,
                                                                      '', NVL (
                                                                             i.act_prov_month,
                                                                             TRUNC (
                                                                                SYSDATE,
                                                                                'mm')),
                                                                      TO_DATE (
                                                                         :act_prov_month_s,
                                                                         'dd.mm.yyyy'))
                                                               AND DECODE (
                                                                      :act_prov_month_e,
                                                                      '', NVL (
                                                                             i.act_prov_month,
                                                                             TRUNC (
                                                                                SYSDATE,
                                                                                'mm')),
                                                                      TO_DATE (
                                                                         :act_prov_month_e,
                                                                         'dd.mm.yyyy'))
         AND NVL (i.oplata_date, TRUNC (SYSDATE, 'mm')) BETWEEN DECODE (
                                                                   :oplata_date_s,
                                                                   '', NVL (
                                                                          i.oplata_date,
                                                                          TRUNC (
                                                                             SYSDATE,
                                                                             'mm')),
                                                                   TO_DATE (
                                                                      :oplata_date_s,
                                                                      'dd.mm.yyyy'))
                                                            AND DECODE (
                                                                   :oplata_date_e,
                                                                   '', NVL (
                                                                          i.oplata_date,
                                                                          TRUNC (
                                                                             SYSDATE,
                                                                             'mm')),
                                                                   TO_DATE (
                                                                      :oplata_date_e,
                                                                      'dd.mm.yyyy'))
         AND NVL (TRUNC (i.invoice_sended_lu, 'mm'), TRUNC (SYSDATE, 'mm')) BETWEEN DECODE (
                                                                                       :invoice_sended_s,
                                                                                       '', NVL (
                                                                                              TRUNC (
                                                                                                 i.invoice_sended_lu,
                                                                                                 'mm'),
                                                                                              TRUNC (
                                                                                                 SYSDATE,
                                                                                                 'mm')),
                                                                                       TO_DATE (
                                                                                          :invoice_sended_s,
                                                                                          'dd.mm.yyyy'))
                                                                                AND DECODE (
                                                                                       :invoice_sended_e,
                                                                                       '', NVL (
                                                                                              TRUNC (
                                                                                                 i.invoice_sended_lu,
                                                                                                 'mm'),
                                                                                              TRUNC (
                                                                                                 SYSDATE,
                                                                                                 'mm')),
                                                                                       TO_DATE (
                                                                                          :invoice_sended_e,
                                                                                          'dd.mm.yyyy'))
         AND (   DECODE ( :show, 'all', 0) = 0
              OR DECODE ( :show, 'opl', 1) = i.oplachen
              OR DECODE ( :show, 'noopl', 0) = NVL (i.oplachen, 0)
              OR DECODE ( :show, 'dolg_act', NVL (i.dolg_act, 0)) = 0
              OR DECODE ( :show, 'dolg_nal', NVL (i.dolg_nal, 0)) = 0)
         AND i.ok_fm = 1
         AND i.invoice_sended = 1
         AND DECODE ( :urlic, 0, 0, :urlic) = DECODE ( :urlic, 0, 0, u.id)
         AND i.promo = 0
ORDER BY DECODE ( :sort,
                 0, i.data,
                 1, i.oplata_date,
                 2, i.invoice_sended_lu) DESC