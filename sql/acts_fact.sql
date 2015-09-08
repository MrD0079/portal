/* Formatted on 17/07/2015 15:03:55 (QP5 v5.227.12220.39724) */
  SELECT i.*,
         n.net_name,
         fn_getname (n.tn_mkk) mkk,
         fn_getname (n.tn_rmkk) rmkk,
         TO_CHAR (i.DATA, 'dd.mm.yyyy') data_t,
         TO_CHAR (i.lu, 'dd.mm.yyyy hh24:mi:ss') lu_t,
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
         c.mt || ' ' || c.y act_prov_month_t
    FROM invoice i,
         nets n,
         bud_fil p,
         urlic u,
         calendar c
   WHERE     c.data = i.act_prov_month
         AND n.id_net = i.id_net
         AND i.payer = p.id
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
         AND (   DECODE (:okact, 'all', 0) = 0
              OR DECODE (:okact, 'no', 0) =
                    DECODE (i.act_prov_month, NULL, 0, 1)
              OR DECODE (:okact, 'ok', 1) =
                    DECODE (i.act_prov_month, NULL, 0, 1))
         AND i.promo = 0
         AND i.oplachen=1
ORDER BY i.DATA DESC