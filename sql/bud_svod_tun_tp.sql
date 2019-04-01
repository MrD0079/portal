/* Formatted on 06/06/2016 14:02:13 (QP5 v5.252.13127.32867) */
  SELECT u.fio ts,
         s.h_eta,
         s.eta,
         s.tp_ur tp_name,
         s.tp_addr,
         s.tp_kod,
         s.tp_type,
         s.bedt_summ,
         NVL(tc_st.status,-1) as status,
         tc_st.date_upd as tc_status_upd,
         t.delay,
         t.discount,
         t.bonus,
         t.fixed,
         t.margin,
         (SELECT fn
            FROM sc_files
           WHERE     id = (SELECT MAX (id)
                             FROM sc_files
                            WHERE tp_kod = t.tp_kod AND dpt_id = :dpt_id)
                 AND dpt_id = :dpt_id)
            last_fn,
         s.summa,
         DECODE (sv.tp_kod, NULL, NULL, 1) selected,
         NVL (s.summa, 0) * t.bonus / 100 bonus_tp,
         NVL (sv.fixed_fakt, 0) fixed_fakt,
         NVL (sv.bonus_fakt, 0) + NVL (sv.fixed_fakt, 0) total,
         DECODE (
            NVL (s.summa, 0),
            0, 0,
            (NVL (sv.bonus_fakt, 0) + NVL (sv.fixed_fakt, 0)) / s.summa * 100)
            zat,
         (SELECT parent
            FROM parents
           WHERE tn = u.tn)
            parent_tn,
         sv.lu_fio,
         sv.lu_tn,
         TO_CHAR (sv.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
         s.skidka skidka,
         -s.summskidka skidka_val,
         sv.bonus_fakt,
         NVL (sv.fixed_fakt, 0) + NVL (s.summa, 0) * t.bonus / 100 maxtp,
         sv.cash,
           (NVL (sv.bonus_fakt, 0) + NVL (sv.fixed_fakt, 0))
         * CASE
              WHEN NVL (sv.cash, 0) = 1
              THEN
                 1
              ELSE
                   (  1
                    -   NVL (
                           (SELECT discount
                              FROM bud_fil_discount_body
                             WHERE     dt = TO_DATE ( :dt, 'dd.mm.yyyy')
                                   AND distr = zp.fil),
                           0)
                      / 100)
                 * (SELECT bonus_log_koef
                      FROM bud_fil
                     WHERE id = zp.fil)
           END
            compens_distr,
         taf.ok_db_tn taf_ok_db_tn
    FROM (SELECT m.tab_num,
                 m.tp_kod,
                 m.y,
                 m.m,
                 NVL (m.summa, 0) + NVL (m.coffee, 0) summa,
                 m.h_eta,
                 m.eta,
                 m.skidka,
                 m.summskidka,
                 m.bedt_summ,
                 m.tp_type,
                 m.tp_ur,
                 m.tp_addr
            FROM a14mega m
           WHERE m.dpt_id = :dpt_id AND TO_DATE ( :dt, 'dd.mm.yyyy') = m.dt) s,
         user_list u,
         (  SELECT id,
                   tp_kod,
                   chain,
                   AVG (delay) delay,
                   AVG (discount) discount,
                   AVG (bonus) bonus,
                   AVG (fixed) fixed,
                   AVG (margin) margin
              FROM (SELECT z.id,
                           TO_NUMBER (getZayFieldVal (z.id, 'admin_id', 14))
                              chain,
                           TO_NUMBER (getZayFieldVal (z.id, 'admin_id', 4))
                              tp_kod,
                           TO_NUMBER (getZayFieldVal (z.id, 'var1', 710)) delay,
                           TO_NUMBER (getZayFieldVal (z.id, 'var1', 1000))
                              discount,
                           TO_NUMBER (getZayFieldVal (z.id, 'var1', 1010)) bonus,
                           TO_NUMBER (getZayFieldVal (z.id, 'var1', 1020)) fixed,
                           TO_NUMBER (getZayFieldVal (z.id, 'var1', 735)) margin,
                           u.dpt_id
                      FROM bud_ru_zay z, user_list u
                     WHERE     (SELECT NVL (tu, 0)
                                  FROM bud_ru_st_ras
                                 WHERE id = z.kat) = 1
                           AND z.tn = u.tn
                           AND u.dpt_id = :dpt_id
                           AND TO_DATE ( :dt, 'dd.mm.yyyy') BETWEEN TRUNC (
                                                                       z.dt_start,
                                                                       'mm')
                                                                AND TRUNC (
                                                                       z.dt_end,
                                                                       'mm')
                           AND z.report_data IS NOT NULL
                           AND (SELECT rep_accepted
                                  FROM bud_ru_zay_accept
                                 WHERE     z_id = z.id AND INN_not_ReportMA (tn) = 0
                                       AND accept_order =
                                              DECODE (
                                                 NVL (
                                                    (SELECT MAX (accept_order)
                                                       FROM bud_ru_zay_accept
                                                      WHERE     z_id = z.id
                                                            AND rep_accepted = 2 AND INN_not_ReportMA (tn) = 0),
                                                    0),
                                                 0, (SELECT MAX (accept_order)
                                                       FROM bud_ru_zay_accept
                                                      WHERE     z_id = z.id
                                                            AND rep_accepted
                                                                   IS NOT NULL AND INN_not_ReportMA (tn) = 0),
                                                 (SELECT MAX (accept_order)
                                                    FROM bud_ru_zay_accept
                                                   WHERE     z_id = z.id
                                                         AND rep_accepted = 2 AND INN_not_ReportMA (tn) = 0))) =
                                  1                                      /*0*/
                           AND TO_NUMBER (getZayFieldVal (z.id, 'admin_id', 4))
                                  IS NOT NULL)
          GROUP BY id, tp_kod, chain) t,
         sc_svodn sv,
         (SELECT fil, h_eta
            FROM bud_svod_zp
           WHERE     dt = TO_DATE ( :dt, 'dd.mm.yyyy')
                 AND dpt_id = :dpt_id
                 AND fil IS NOT NULL) zp,
         (SELECT fil, ok_db_tn
            FROM bud_svod_taf
           WHERE dt = TO_DATE ( :dt, 'dd.mm.yyyy')) taf,
        tc_status tc_st
   WHERE     zp.fil = taf.fil(+)
         AND t.id = tc_st.zay_id(+)
         AND s.tab_num = u.tab_num
         AND u.dpt_id = :dpt_id
   and u.is_spd=1
      AND s.tp_kod = t.tp_kod
         AND s.tp_kod = sv.tp_kod(+)
         AND sv.dt(+) = TO_DATE ( :dt, 'dd.mm.yyyy')
         AND :dpt_id = sv.dpt_id(+)
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
         AND DECODE ( :ok_bonus,  1, 0,  2, sv.tp_kod) =
                DECODE ( :ok_bonus,  1, 0,  2, NVL (sv.tp_kod, 0))
         AND zp.h_eta = s.h_eta
         AND (zp.fil = :fil OR :fil = 0)
         AND (   zp.fil IN (SELECT fil_id
                              FROM clusters_fils
                             WHERE :clusters = CLUSTER_ID)
              OR :clusters = 0)
ORDER BY ts, eta, tp_name