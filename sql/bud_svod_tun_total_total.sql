/* Formatted on 06/06/2016 14:02:22 (QP5 v5.252.13127.32867) */
SELECT COUNT (*) c,
       SUM (summa) summa,
       SUM (selected) selected,
       SUM (bonus_tp) bonus_tp,
       SUM (fixed_fakt) fixed_fakt,
       SUM (total) total,
       DECODE (
          SUM (DECODE (selected, 1, summa, NULL)),
          0, 0,
          NVL (
               SUM (DECODE (selected, 1, total, NULL))
             / SUM (DECODE (selected, 1, summa, NULL))
             * 100,
             0))
          zat,
       SUM (bonus_fakt) bonus_fakt,
       SUM (maxtp) maxtp,
       SUM (cash) cash,
       SUM (compens_distr) compens_distr,
       DECODE (SUM (summa), 0, 0, -SUM (skidka_val) / SUM (summa) * 100)
          skidka,
       -SUM (skidka_val) skidka_val
  FROM (SELECT 'tp' || s.tp_kod,
               s.summa,
               DECODE (sv.tp_kod, 0, 0, 1) selected,
               NVL (s.summa, 0) * t.bonus / 100 bonus_tp,
               NVL (sv.fixed_fakt, 0) fixed_fakt,
               NVL (sv.bonus_fakt, 0) + NVL (sv.fixed_fakt, 0) total,
               -s.summskidka skidka_val,
               sv.bonus_fakt,
               NVL (sv.fixed_fakt, 0) + NVL (s.summa, 0) * t.bonus / 100
                  maxtp,
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
                                   WHERE     dt =
                                                TO_DATE ( :dt, 'dd.mm.yyyy')
                                         AND distr = zp.fil),
                                 0)
                            / 100)
                       * (SELECT bonus_log_koef
                            FROM bud_fil
                           WHERE id = zp.fil)
                 END
                  compens_distr
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
                 WHERE     m.dpt_id = :dpt_id
                       AND TO_DATE ( :dt, 'dd.mm.yyyy') = m.dt) s,
               user_list u,
               (  SELECT tp_kod,
                         chain,
                         AVG (delay) delay,
                         AVG (discount) discount,
                         AVG (bonus) bonus,
                         AVG (fixed) fixed,
                         AVG (margin) margin
                    FROM (SELECT z.id,
                                 TO_NUMBER (
                                    getZayFieldVal (z.id, 'admin_id', 14))
                                    chain,
                                 TO_NUMBER (
                                    getZayFieldVal (z.id, 'admin_id', 4))
                                    tp_kod,
                                 TO_NUMBER (getZayFieldVal (z.id, 'var1', 710))
                                    delay,
                                 TO_NUMBER (
                                    getZayFieldVal (z.id, 'var1', 1000))
                                    discount,
                                 TO_NUMBER (
                                    getZayFieldVal (z.id, 'var1', 1010))
                                    bonus,
                                 TO_NUMBER (
                                    getZayFieldVal (z.id, 'var1', 1020))
                                    fixed,
                                 TO_NUMBER (getZayFieldVal (z.id, 'var1', 735))
                                    margin,
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
                                       WHERE     z_id = z.id
                                             AND accept_order =
                                                    DECODE (
                                                       NVL (
                                                          (SELECT MAX (
                                                                     accept_order)
                                                             FROM bud_ru_zay_accept
                                                            WHERE     z_id =
                                                                         z.id
                                                                  AND rep_accepted =
                                                                         2),
                                                          0),
                                                       0, (SELECT MAX (
                                                                     accept_order)
                                                             FROM bud_ru_zay_accept
                                                            WHERE     z_id =
                                                                         z.id
                                                                  AND rep_accepted
                                                                         IS NOT NULL),
                                                       (SELECT MAX (
                                                                  accept_order)
                                                          FROM bud_ru_zay_accept
                                                         WHERE     z_id = z.id
                                                               AND rep_accepted =
                                                                      2))) = 1 /*0*/
                                 AND TO_NUMBER (
                                        getZayFieldVal (z.id, 'admin_id', 4))
                                        IS NOT NULL)
                GROUP BY tp_kod, chain) t,
               sc_svodn sv,
               (SELECT fil, h_eta
                  FROM bud_svod_zp
                 WHERE     dt = TO_DATE ( :dt, 'dd.mm.yyyy')
                       AND dpt_id = :dpt_id
                       AND fil IS NOT NULL) zp,
               (SELECT fil, ok_db_tn
                  FROM bud_svod_taf
                 WHERE dt = TO_DATE ( :dt, 'dd.mm.yyyy')) taf
         WHERE     zp.fil = taf.fil(+)
               AND s.tab_num = u.tab_num
               AND u.dpt_id = :dpt_id
               AND s.tp_kod = t.tp_kod
               AND s.tp_kod = sv.tp_kod(+)
               AND sv.dt(+) = TO_DATE ( :dt, 'dd.mm.yyyy')
               AND :dpt_id = sv.dpt_id(+)
               AND (   :exp_list_without_ts = 0
                    OR u.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_without_ts))
               AND (   :exp_list_without_ts = 0
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
        UNION
          SELECT 'net' || s.net_kod,
                 SUM (s.summa) summa,
                 SUM (DECODE (sv.net_kod, 0, 0, 1)) selected,
                 SUM (s.summa) * s.bonus / 100 bonus_tp,
                 NVL (SUM (sv.fixed_fakt), 0) fixed_fakt,
                 NVL (SUM (sv.bonus_fakt), 0) + NVL (SUM (sv.fixed_fakt), 0)
                    total,
                 SUM (skidka_val) skidka_val,
                 NVL (SUM (sv.bonus_fakt), 0) bonus_fakt,
                 NVL (SUM (sv.fixed_fakt), 0) + SUM (s.summa) * s.bonus / 100
                    maxtp,
                 SUM (sv.cash) cash,
                 SUM (
                      (NVL (sv.bonus_fakt, 0) + NVL (sv.fixed_fakt, 0))
                    * CASE
                         WHEN NVL (sv.cash, 0) = 1 THEN 1
                         ELSE s.compens_distr_koef
                      END)
                    compens_distr
            FROM (  SELECT s.net_kod,
                           s.net,
                           s.isrc,
                           s.db,
                           s.fil,
                           s.fname,
                           COUNT (*) tp_cnt,
                           t.delay,
                           t.discount,
                           t.bonus,
                           t.fixed,
                           t.margin,
                           SUM (s.summa) summa,
                           SUM (s.summa) * t.bonus / 100 bonus_tp,
                           DECODE (SUM (s.summa),
                                   0, 0,
                                   -SUM (s.summskidka) / SUM (s.summa) * 100)
                              skidka,
                           -SUM (s.summskidka) skidka_val,
                             (  1
                              -   NVL (
                                     (SELECT discount
                                        FROM bud_fil_discount_body
                                       WHERE     dt =
                                                    TO_DATE ( :dt, 'dd.mm.yyyy')
                                             AND distr = s.fil),
                                     0)
                                / 100)
                           * (SELECT bonus_log_koef
                                FROM bud_fil
                               WHERE id = s.fil)
                              compens_distr_koef,
                           taf.ok_db_tn taf_ok_db_tn
                      FROM (SELECT tpn.net_kod,
                                   tpn.net,
                                   tpn.isrc,
                                   u.tn,
                                   p.parent db,
                                   m.tab_num,
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
                                   m.tp_addr,
                                   f.id fil,
                                   f.name fname
                              FROM a14mega m,
                                   user_list u,
                                   parents p,
                                   tp_nets tpn,
                                   bud_fil f,
                                   bud_tn_fil tf
                             WHERE     m.tp_kod = tpn.tp_kod
                                   AND u.tn = p.tn
                                   AND m.dpt_id = :dpt_id
                                   AND TO_DATE ( :dt, 'dd.mm.yyyy') = m.dt
                                   AND u.tab_num = m.tab_num
                                   AND u.dpt_id = m.dpt_id
                                   AND f.id = tf.bud_id
                                   AND tf.tn = p.parent
                                   AND f.dpt_id = m.dpt_id
                                   AND (   f.data_end IS NULL
                                        OR TRUNC (f.data_end, 'mm') >=
                                              TO_DATE ( :dt, 'dd.mm.yyyy'))) s,
                           (SELECT DISTINCT
                                   TO_NUMBER (
                                      getZayFieldVal (z.id, 'admin_id', 14))
                                      chain,
                                   TO_NUMBER (getZayFieldVal (z.id, 'var1', 710))
                                      delay,
                                   TO_NUMBER (
                                      getZayFieldVal (z.id, 'var1', 1000))
                                      discount,
                                   TO_NUMBER (
                                      getZayFieldVal (z.id, 'var1', 1010))
                                      bonus,
                                   TO_NUMBER (
                                      getZayFieldVal (z.id, 'var1', 1020))
                                      fixed,
                                   TO_NUMBER (getZayFieldVal (z.id, 'var1', 735))
                                      margin
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
                                         WHERE     z_id = z.id
                                               AND accept_order =
                                                      DECODE (
                                                         NVL (
                                                            (SELECT MAX (
                                                                       accept_order)
                                                               FROM bud_ru_zay_accept
                                                              WHERE     z_id =
                                                                           z.id
                                                                    AND rep_accepted =
                                                                           2),
                                                            0),
                                                         0, (SELECT MAX (
                                                                       accept_order)
                                                               FROM bud_ru_zay_accept
                                                              WHERE     z_id =
                                                                           z.id
                                                                    AND rep_accepted
                                                                           IS NOT NULL),
                                                         (SELECT MAX (
                                                                    accept_order)
                                                            FROM bud_ru_zay_accept
                                                           WHERE     z_id = z.id
                                                                 AND rep_accepted =
                                                                        2))) = 1
                                   AND TO_NUMBER (
                                          getZayFieldVal (z.id, 'admin_id', 14))
                                          IS NOT NULL) t,
                           (SELECT fil, h_eta
                              FROM bud_svod_zp
                             WHERE     dt = TO_DATE ( :dt, 'dd.mm.yyyy')
                                   AND dpt_id = :dpt_id
                                   AND fil IS NOT NULL) zp,
                           (SELECT fil, ok_db_tn
                              FROM bud_svod_taf
                             WHERE dt = TO_DATE ( :dt, 'dd.mm.yyyy')) taf
                     WHERE     zp.fil = taf.fil(+)
                           AND s.net_kod = t.chain
                           AND s.fil = zp.fil(+)
                           AND (   :exp_list_without_ts = 0
                                OR s.tn IN (SELECT slave
                                              FROM full
                                             WHERE master = :exp_list_without_ts))
                           AND (   :exp_list_only_ts = 0
                                OR s.tn IN (SELECT slave
                                              FROM full
                                             WHERE master = :exp_list_only_ts))
                           AND (   s.tn IN (SELECT slave
                                              FROM full
                                             WHERE master = :tn)
                                OR (SELECT NVL (is_traid, 0)
                                      FROM user_list
                                     WHERE tn = :tn) = 1
                                OR (SELECT NVL (is_traid_kk, 0)
                                      FROM user_list
                                     WHERE tn = :tn) = 1)
                           AND (:eta_list is null OR :eta_list = s.h_eta)
                           AND zp.h_eta = s.h_eta
                           AND (zp.fil = :fil OR :fil = 0)
                           AND (   zp.fil IN (SELECT fil_id
                                                FROM clusters_fils
                                               WHERE :clusters = CLUSTER_ID)
                                OR :clusters = 0)
                  GROUP BY s.net_kod,
                           s.net,
                           s.isrc,
                           s.fil,
                           s.fname,
                           t.delay,
                           t.discount,
                           t.bonus,
                           t.fixed,
                           t.margin,
                           s.db,
                           taf.ok_db_tn) s,
                 sc_svodn sv
           WHERE     s.net_kod = sv.net_kod(+)
                 AND s.fil = sv.fil(+)
                 AND s.db = sv.db(+)
                 AND TO_DATE ( :dt, 'dd.mm.yyyy') = sv.dt(+)
                 AND :dpt_id = sv.dpt_id(+)
                 AND DECODE ( :ok_bonus,  1, 0,  2, sv.net_kod) =
                        DECODE ( :ok_bonus,  1, 0,  2, NVL (sv.net_kod, 0))
        GROUP BY s.net_kod,
                 s.net,
                 s.isrc,
                 s.delay,
                 s.discount,
                 s.bonus,
                 s.fixed,
                 s.margin,
                 s.db,
                 s.taf_ok_db_tn)