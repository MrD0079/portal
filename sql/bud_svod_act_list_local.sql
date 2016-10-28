/* Formatted on 09/04/2015 17:40:10 (QP5 v5.227.12220.39724) */
  SELECT z.id,
         z.dt_start,
         z.fil,
         f.name fil_name,
         zff1.val_string,
         zff2.val_textarea,
         zff3.rep_val_number * 1000 bonus_tma,
                 NVL (kat.tu, 0) tu
    FROM bud_ru_zay z,
         user_list u,
         user_list u2,
         BUD_RU_st_ras st,
         BUD_RU_st_ras kat,
         bud_fil f,
         bud_funds fu,
         nets n,
         bud_ru_zay_ff zff1,
         bud_ru_ff ff1,
         bud_ru_zay_ff zff2,
         bud_ru_ff ff2,
         bud_ru_zay_ff zff3,
         bud_ru_ff ff3,
         (SELECT DISTINCT t.z_id
            FROM (SELECT m.tab_num,
                         m.tp_kod,
                         m.y,
                         m.m,
                         m.summa,
                         m.h_eta,
                         m.eta
                    FROM a14mega m
                   WHERE     m.dpt_id = :dpt_id
                         AND TO_DATE (:dt, 'dd.mm.yyyy') = m.dt) s,
                 user_list u,
                 akcii_local_tp t,
                 bud_ru_zay z
           WHERE     s.tp_kod = t.tp_kod
                 AND t.z_id = z.id
                 AND s.tab_num = u.tab_num
                 AND u.dpt_id = :dpt_id
                 /*AND u.datauvol IS NULL*/
                 AND (   :exp_list_without_ts = 0
                      OR u.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_without_ts))
                 AND (   :exp_list_only_ts = 0
                      OR u.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_only_ts))
                 AND (   u.tn IN (SELECT slave
                                    FROM full
                                   WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1
                      OR (SELECT NVL (is_traid_kk, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND (:eta_list is null OR :eta_list = s.h_eta)
                 AND DECODE (:fil, 0, z.fil, :fil) = z.fil
                 AND (   z.fil IN (SELECT fil_id
                                     FROM clusters_fils
                                    WHERE :clusters = CLUSTER_ID)
                      OR :clusters = 0)
                 AND z.tn = DECODE (:db, 0, z.tn, :db)) t
   WHERE     t.z_id = z.id
         AND z.id_net = n.id_net(+)
         AND z.fil = f.id
         AND z.funds = fu.id
         AND z.tn = u.tn
         AND z.recipient = u2.tn
         AND u.dpt_id = :dpt_id
         AND z.st = st.id(+)
         AND z.kat = kat.id(+)
         AND kat.la = 1
         AND z.id = zff1.z_id
         AND zff1.ff_id = ff1.id
         AND ff1.admin_id = 1
         AND z.id = zff2.z_id
         AND zff2.ff_id = ff2.id
         AND ff2.admin_id = 2
         AND z.id = zff3.z_id
         AND zff3.ff_id = ff3.id
         AND ff3.rep_var_name = 'rv3'
         AND (SELECT accepted
                FROM bud_ru_zay_accept
               WHERE     z_id = z.id
                     AND accept_order =
                            DECODE (
                               NVL (
                                  (SELECT MAX (accept_order)
                                     FROM bud_ru_zay_accept
                                    WHERE z_id = z.id AND accepted = 2),
                                  0),
                               0, (SELECT MAX (accept_order)
                                     FROM bud_ru_zay_accept
                                    WHERE z_id = z.id),
                               (SELECT MAX (accept_order)
                                  FROM bud_ru_zay_accept
                                 WHERE z_id = z.id AND accepted = 2))) =
                1
         AND valid_no = 0
         AND TRUNC (z.dt_start, 'mm') = TO_DATE (:dt, 'dd.mm.yyyy')
ORDER BY val_string, fil_name