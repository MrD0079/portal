/* Formatted on 07.11.2017 18:08:49 (QP5 v5.252.13127.32867) */
  SELECT z.id,
         z.dt_start,
         z.fil fil_id,
         z.st,
         st.name st_name,
         z.kat,
         kat.name kat_name,
         t.c,
         t.summa,
         t.bonus_sum,
         t.compens_distr,
         t.compens_db,
         f.name fil_name,
         zff1.val_string,
         zff2.val_textarea,
         zff3.rep_val_number * 1000 bonus_tma,
         (SELECT mt || ' ' || y
            FROM calendar
           WHERE data = z.cost_assign_month)
            cost_assign_month_text,
         CASE
            WHEN z.cost_assign_month BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                         AND TO_DATE ( :ed, 'dd.mm.yyyy')
            THEN
               1
         END
            cost_assign_month_is_in_period,
         t.period,
         (SELECT mt || ' ' || y
            FROM calendar
           WHERE data = t.period)
            period_text,
         NVL (kat.tu, 0) tu,
         (SELECT rep_accepted
            FROM bud_ru_zay_accept
           WHERE     z_id = z.id
                 AND INN_not_ReportMA (tn) = 0
                 AND accept_order =
                        DECODE (
                           NVL (
                              (SELECT MAX (accept_order)
                                 FROM bud_ru_zay_accept
                                WHERE     z_id = z.id
                                      AND rep_accepted = 2
                                      AND INN_not_ReportMA (tn) = 0),
                              0),
                           0, (SELECT MAX (accept_order)
                                 FROM bud_ru_zay_accept
                                WHERE     z_id = z.id
                                      AND rep_accepted IS NOT NULL
                                      AND INN_not_ReportMA (tn) = 0),
                           (SELECT MAX (accept_order)
                              FROM bud_ru_zay_accept
                             WHERE     z_id = z.id
                                   AND rep_accepted = 2
                                   AND INN_not_ReportMA (tn) = 0)))
            rep_current_accepted_id
    FROM bud_ru_zay z,
         user_list u,
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
         (  SELECT z.id,
                   COUNT (*) c,
                   SUM (s.summa) summa,
                     (  NVL (getZayFieldVal (z.id, 'rep_var_name', 'rv3'), 0)
                      + NVL (getZayFieldVal (z.id, 'rep_var_name', 'rv4'), 0))
                   * 1000
                      bonus_sum,
                     (  NVL (getZayFieldVal (z.id, 'rep_var_name', 'rv3'), 0)
                      + NVL (getZayFieldVal (z.id, 'rep_var_name', 'rv4'), 0))
                   * 1000
                   * CASE
                        WHEN NVL (TO_NUMBER (getZayFieldVal (z.id, 'admin_id', 9)),
                                  0) = 1
                        THEN
                           0
                        WHEN NVL (TO_NUMBER (getZayFieldVal (z.id, 'admin_id', 8)),
                                  0) = 0
                        THEN
                           1
                        ELSE
                             (  1
                              -   NVL (
                                     (SELECT discount
                                        FROM bud_fil_discount_body
                                       WHERE     dt = TRUNC (z.dt_start, 'mm')
                                             AND distr = z.fil),
                                     0)
                                / 100)
                           * (SELECT bonus_log_koef
                                FROM bud_fil
                               WHERE id = z.fil)
                     END
                      compens_distr,
                     (  NVL (getZayFieldVal (z.id, 'rep_var_name', 'rv3'), 0)
                      + NVL (getZayFieldVal (z.id, 'rep_var_name', 'rv4'), 0))
                   * 1000
                   * CASE
                        WHEN NVL (TO_NUMBER (getZayFieldVal (z.id, 'admin_id', 9)),
                                  0) = 1
                        THEN
                           1
                     END
                      compens_db,
                   TRUNC (z.dt_start, 'mm') period
              FROM (SELECT m.dt,
                           m.tab_num,
                           m.tp_kod,
                           m.y,
                           m.m,
                           m.summa,
                           m.h_eta,
                           m.eta
                      FROM a14mega m
                     WHERE     m.dpt_id = :dpt_id
                           /*AND m.dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                        AND TO_DATE ( :ed, 'dd.mm.yyyy')*/) s,
                   akcii_local_tp t,
                   bud_ru_zay z
             WHERE     s.tp_kod = t.tp_kod
                   AND t.z_id = z.id
                   AND ( :eta_list IS NULL OR :eta_list = s.h_eta)
                   AND DECODE ( :fil, 0, z.fil, :fil) = z.fil
                   AND z.funds = DECODE ( :funds, 0, z.funds, :funds)
                   AND (   z.fil IN (SELECT fil_id
                                       FROM clusters_fils
                                      WHERE :clusters = CLUSTER_ID)
                        OR :clusters = 0)
                   AND s.dt IN (z.cost_assign_month, TRUNC (z.dt_start, 'mm'))
          GROUP BY z.id, z.fil, z.dt_start) t
   WHERE     t.id = z.id
         AND z.id_net = n.id_net(+)
         AND z.fil = f.id
         AND z.funds = fu.id
         AND z.funds = DECODE ( :funds, 0, z.funds, :funds)
         AND z.tn = u.tn
         AND u.dpt_id = :dpt_id
         AND u.is_spd = 1
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
                            DECODE (NVL ( (SELECT MAX (accept_order)
                                             FROM bud_ru_zay_accept
                                            WHERE z_id = z.id AND accepted = 2),
                                         0),
                                    0, (SELECT MAX (accept_order)
                                          FROM bud_ru_zay_accept
                                         WHERE z_id = z.id),
                                    (SELECT MAX (accept_order)
                                       FROM bud_ru_zay_accept
                                      WHERE z_id = z.id AND accepted = 2))) = 1
         AND z.valid_no = 0
         AND (   TRUNC (z.dt_start, 'mm') BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                              AND TO_DATE ( :ed, 'dd.mm.yyyy')
              OR z.cost_assign_month BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                         AND TO_DATE ( :ed, 'dd.mm.yyyy'))
         AND u.tn = DECODE ( :db, 0, u.tn, :db)
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
         AND DECODE ( :st, 0, z.st, :st) = z.st
         AND t.period IN (z.cost_assign_month, TRUNC (z.dt_start, 'mm'))
ORDER BY t.period, val_string, fil_name