/* Formatted on 03.10.2014 16:57:27 (QP5 v5.227.12220.39724) */
  SELECT i.*,
         n.net_name,
         fn_getname ( n.tn_mkk) mkk,
         fn_getname ( n.tn_rmkk) rmkk,
         TO_CHAR (i.DATA, 'dd.mm.yyyy') data_t,
         TO_CHAR (i.act_dt, 'dd.mm.yyyy') act_dt_t,
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
         u.name urlic_name
    FROM invoice i,
         nets n,
         bud_fil p,
         urlic u
   WHERE     n.id_net = i.id_net
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
         AND (   DECODE (:okfm, 'all', 0) = 0
              OR DECODE (:okfm, 'no', 0) = nvl(i.ok_fm,0)
              OR DECODE (:okfm, 'ok', 1) = nvl(i.ok_fm,0))
         AND (   DECODE (:oknmkk, 'all', 0) = 0
              OR DECODE (:oknmkk, 'no', 0) = nvl(i.ok_nmkk,0)
              OR DECODE (:oknmkk, 'ok', 1) = nvl(i.ok_nmkk,0))
         AND i.promo=0
         AND DECODE (:payer, 0, i.payer, :payer) = i.payer
ORDER BY DATA DESC