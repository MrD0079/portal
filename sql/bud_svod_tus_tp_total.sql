/* Formatted on 06/06/2016 14:17:00 (QP5 v5.252.13127.32867) */
SELECT COUNT (*) c,
       SUM (summa) summa,
       SUM (selected) selected,
       SUM (summa_return) summa_return,
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
       SUM (DECODE (ok_db_tn, NULL, 0, 1)) ok_db,
       SUM (bonus_fakt) bonus_fakt,
       SUM (maxtp) maxtp,
       SUM (cash) cash,
       SUM (compens_distr) compens_distr,
       DECODE (SUM (summa), 0, 0, SUM (skidka_val) / SUM (summa) * 100)
          skidka,
       SUM (skidka_val) skidka_val
  FROM (  SELECT u.fio ts,
                 s.h_eta,
                 s.eta,
                 s.tp_ur tp_name,
                 s.tp_addr,
                 s.tp_kod,
                 s.tp_type,
                 s.bedt_summ,
                 t.delay,
                 t.discount,
                 t.bonus,
                 t.justification,
                 NVL (t.fixed, 0) fixed,
                 t.margin,
                 (SELECT fn
                    FROM sc_files
                   WHERE     id =
                                (SELECT MAX (id)
                                   FROM sc_files
                                  WHERE tp_kod = t.tp_kod AND dpt_id = :dpt_id)
                         AND dpt_id = :dpt_id)
                    last_fn,
                 s.summa summa,
                 DECODE (sv.tp_kod, NULL, NULL, 1) selected,
                 NVL (sv.summa_return, 0) summa_return,
                 (s.summa) * t.bonus / 100 bonus_tp,
                 NVL (sv.fixed_fakt, 0) fixed_fakt,
                 NVL (sv.bonus_fakt, 0) + NVL (sv.fixed_fakt, 0) total,
                 DECODE (
                    s.summa,
                    0, 0,
                      (NVL (sv.bonus_fakt, 0) + NVL (sv.fixed_fakt, 0))
                    / (s.summa)
                    * 100)
                    zat,
                 (SELECT parent
                    FROM parents
                   WHERE tn = u.tn)
                    parent_tn,
                 sv.ok_db_tn,
                 sv.ok_db_fio,
                 TO_CHAR (sv.ok_db_lu, 'dd.mm.yyyy hh24:mi:ss') ok_db_lu,
                 s.skidka skidka,
                 -s.summskidka skidka_val,
                 sv.bonus_fakt,
                   NVL (sv.fixed_fakt, 0)
                 + NVL (sv.summa_return, 0) * t.bonus / 100
                    maxtp,
                 sv.cash,
                 sv.comm,
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
                         m.tp_addr,
                         m.coffee
                    FROM a14mega m
                   WHERE     m.dpt_id = :dpt_id
                         AND TO_DATE ( :dt, 'dd.mm.yyyy') = m.dt) s,
                 user_list u,
                 sc_tp t,
                 sc_svod sv,
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
            and u.is_spd=1
     AND :dpt_id = t.dpt_id(+)
                 AND s.tp_kod = t.tp_kod(+)
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
                 AND (   discount > 0
                      OR bonus > 0
                      OR fixed > 0
                      OR margin > 0
                      OR sv.bonus_fakt > 0
                      OR sv.fixed_fakt > 0)
                 AND DECODE ( :ok_bonus,  1, 0,  2, sv.tp_kod) =
                        DECODE ( :ok_bonus,  1, 0,  2, NVL (sv.tp_kod, 0))
                 AND DECODE ( :cash, 1, 0, NVL (sv.cash, 0)) =
                        DECODE ( :cash,  1, 0,  2, 1,  3, 0)
                 AND DECODE (
                        :fakt_gt_plan,
                        1, 0,
                        2, CASE
                              WHEN NVL (sv.bonus_fakt, 0) >
                                      NVL (sv.summa_return * t.bonus / 100, 0)
                              THEN
                                 0
                              ELSE
                                 1
                           END) = 0
                 AND zp.h_eta = s.h_eta
                 AND (zp.fil = :fil OR :fil = 0)
                 AND (   zp.fil IN (SELECT fil_id
                                      FROM clusters_fils
                                     WHERE :clusters = CLUSTER_ID)
                      OR :clusters = 0)
        ORDER BY ts, eta, tp_name)