/* Formatted on 27/04/2015 17:06:17 (QP5 v5.227.12220.39724) */
  SELECT i.*,
         n.net_name,
         fn_getname (n.tn_mkk) mkk,
         fn_getname (n.tn_rmkk) rmkk,
         TO_CHAR (i.DATA, 'dd.mm.yyyy') data_t,
         TO_CHAR (i.lu, 'dd.mm.yyyy hh24:mi:ss') lu_t,
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
         TO_CHAR (i.fm_lu, 'dd.mm.yyyy') fm_lu_t,
         TO_CHAR (i.oplata_date, 'dd.mm.yyyy') oplata_date,
         TO_CHAR (i.act_prov_month, 'dd.mm.yyyy') act_prov_month
    FROM invoice i,
         nets n,
         bud_fil p,
         urlic u
   WHERE     n.id_net = i.id_net
         AND i.payer = p.id(+)
         AND u.id(+) = i.urlic
         AND :tn IN (DECODE ( (SELECT pos_id
                                 FROM spdtree
                                WHERE svideninn = :tn),
                             24, n.tn_mkk,
                             34, n.tn_rmkk,
                             63, :tn,
                             65, :tn,
                             67, :tn,
                             (SELECT pos_id
                                FROM user_list
                               WHERE tn = :tn AND is_super = 1), :tn,
                             (SELECT pos_id
                                FROM user_list
                               WHERE tn = :tn AND is_admin = 1), :tn))
         AND DECODE (:tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
         AND DECODE (:tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
         AND DECODE (:nets, 0, n.id_net, :nets) = n.id_net
         AND DECODE (:y, 0, i.y, :y) = i.y
         AND DECODE (:calendar_months, 0, i.m, :calendar_months) = i.m
         AND (   DECODE (:okfm, 'all', 0) = 0
              OR DECODE (:okfm, 'no', 0) = nvl(i.ok_fm,0)
              OR DECODE (:okfm, 'ok', 1) = nvl(i.ok_fm,0))
         AND i.promo = 1
         AND DECODE (
                :payment_type,
                0, 0,
                DECODE (
                   (SELECT COUNT (*)
                      FROM invoice_detail ind, nets_plan_month m
                     WHERE     ind.invoice = i.id
                           AND IND.STATYA = m.id
                           AND DECODE (:payment_type,
                                       0, m.payment_type,
                                       :payment_type) = m.payment_type),
                   0, 0,
                   1)) = DECODE (:payment_type, 0, 0, 1)
         AND NVL (i.oplata_date, TRUNC (SYSDATE)) BETWEEN DECODE (
                                                             :oplata_date_s,
                                                             '', NVL (
                                                                    i.oplata_date,
                                                                    TRUNC (
                                                                       SYSDATE)),
                                                             TO_DATE (
                                                                :oplata_date_s,
                                                                'dd.mm.yyyy'))
                                                      AND DECODE (
                                                             :oplata_date_e,
                                                             '', NVL (
                                                                    i.oplata_date,
                                                                    TRUNC (
                                                                       SYSDATE)),
                                                             TO_DATE (
                                                                :oplata_date_e,
                                                                'dd.mm.yyyy'))
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
         AND DECODE (:z_id, 0, NVL (i.bud_z_id, 0), :z_id) =
                NVL (i.bud_z_id, 0)
ORDER BY DATA DESC