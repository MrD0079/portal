/* Formatted on 25/05/2016 17:56:00 (QP5 v5.252.13127.32867) */
  SELECT SUM (zay_compens_distr) zay_compens_distr,
         SUM (act_local_compens_distr) act_local_compens_distr,
         SUM (act_compens_distr) act_compens_distr,
         SUM (svs_compens_distr) svs_compens_distr,
         SUM (compens_distr) compens_distr,
         SUM (zay_fakt_distr) zay_fakt_distr,
         SUM (act_local_fakt_distr) act_local_fakt_distr,
         SUM (act_fakt_distr) act_fakt_distr,
         SUM (svs_fakt_distr) svs_fakt_distr,
         SUM (fakt_distr) fakt_distr,
         SUM (compens_db) compens_db,
         SUM (skidka_val) skidka_val,
         fil_id,
         name
    FROM (/* Formatted on 25/05/2016 17:55:19 (QP5 v5.252.13127.32867) */
  SELECT tf.fil_id,
         tf.name,
         /*tf.db_list,*/
         zay.z_plan,
         zay.z_fakt,
         zay.compens_distr zay_compens_distr,
         act_local.compens_distr act_local_compens_distr,
         act.compens_distr act_compens_distr,
         NVL (svs.compens_distr, 0) + NVL (svs_new.compens_distr, 0)
            svs_compens_distr,
           NVL (zay.compens_distr, 0)
         + NVL (act_local.compens_distr, 0)
         + NVL (act.compens_distr, 0)
         + NVL (svs.compens_distr, 0)
         + NVL (svs_new.compens_distr, 0)
            compens_distr,
         zay.fakt_distr zay_fakt_distr,
         act_local.fakt_distr act_local_fakt_distr,
         act.fakt_distr act_fakt_distr,
         NVL (svs.fakt_distr, 0) + NVL (svs_new.fakt_distr, 0) svs_fakt_distr,
           NVL (zay.fakt_distr, 0)
         + NVL (act_local.fakt_distr, 0)
         + NVL (act.fakt_distr, 0)
         + NVL (svs.fakt_distr, 0)
         + NVL (svs_new.fakt_distr, 0)
            fakt_distr,
         act_local.compens_db + zay.compens_db compens_db,
         tf.period,
         (SELECT mt || ' ' || y
            FROM calendar
           WHERE data = tf.period)
            period_text,
         NVL (svs.skidka_val, 0) + NVL (svs_new.skidka_val, 0) skidka_val
    FROM (  SELECT f.id fil_id,
                   f.name,
                   tf.bud_id,
                   /*SUBSTR (wm_concat ('<br>' || fio), 5, 4000) db_list,*/
                   c.period
              FROM bud_fil f,
                   bud_tn_fil tf,
                   user_list u,
                   (SELECT DISTINCT TRUNC (data, 'mm') period
                      FROM calendar
                     WHERE data BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                    AND TO_DATE ( :ed, 'dd.mm.yyyy')) c
             WHERE     u.tn = tf.tn
                   AND (   :exp_list_without_ts = 0
                        OR u.tn IN (SELECT slave
                                      FROM full
                                     WHERE master = :exp_list_without_ts))
                   AND (   :exp_list_only_ts = 0
                        OR u.tn IN (SELECT slave
                                      FROM full
                                     WHERE master = :exp_list_only_ts))
                  and u.is_spd=1
 AND (   u.tn IN (SELECT slave
                                      FROM full
                                     WHERE master = :tn)
                        OR (SELECT NVL (is_traid, 0)
                              FROM user_list
                             WHERE tn = :tn) = 1
                        OR (SELECT NVL (is_traid_kk, 0)
                              FROM user_list
                             WHERE tn = :tn) = 1)
                   AND f.dpt_id = :dpt_id
                   AND (   f.data_end IS NULL
                        OR TRUNC (f.data_end, 'mm') >=
                              TO_DATE ( :sd, 'dd.mm.yyyy'))
                   AND DECODE ( :fil, 0, f.id, :fil) = f.id
                   AND (   f.id IN (SELECT fil_id
                                      FROM clusters_fils
                                     WHERE :clusters = CLUSTER_ID)
                        OR :clusters = 0)
                   AND tf.tn = DECODE ( :db, 0, tf.tn, :db)
                   AND f.id = tf.bud_id
          GROUP BY f.id,
                   f.name,
                   tf.bud_id,
                   c.period) tf,
         (  SELECT fil_id,
                   period,
                   COUNT (*) c,
                   SUM (z_plan) z_plan,
                   SUM (z_fakt) z_fakt,
                   SUM (compens_distr) compens_distr,
                   SUM (fakt_distr) fakt_distr,
                   SUM (compens_db) compens_db
              FROM (  SELECT z.fil fil_id,
                             z.*,
                             CASE
                                WHEN via_db = 1
                                THEN
                                   NULL
                                ELSE
                                   CASE
                                      WHEN by_goods = 0
                                      THEN
                                         z_fakt
                                      ELSE
                                           z_fakt
                                         * (  1
                                            -   NVL (
                                                   (SELECT discount
                                                      FROM bud_fil_discount_body
                                                     WHERE     dt = z.period
                                                           AND distr = z.fil),
                                                   0)
                                              / 100)
                                         * (SELECT bonus_log_koef
                                              FROM bud_fil
                                             WHERE id = z.fil)
                                   END
                             END
                                compens_distr,
                             CASE
                                WHEN via_db = 1
                                THEN
                                   NULL
                                ELSE
                                   CASE
                                      WHEN by_goods = 0 THEN z_fakt
                                      ELSE z_fakt
                                   END
                             END
                                fakt_distr,
                             CASE WHEN via_db = 1 THEN z_fakt ELSE NULL END
                                compens_db,
                             (SELECT mt || ' ' || y
                                FROM calendar
                               WHERE data = z.period)
                                period_text
                        FROM (SELECT TRUNC (z.dt_start, 'mm') period,
                                     z.*,
                                     DECODE (
                                        (SELECT COUNT (*)
                                           FROM bud_ru_zay_accept
                                          WHERE z_id = z.id AND accepted = 2),
                                        0, 0,
                                        1)
                                        deleted,
                                     (SELECT accepted
                                        FROM bud_ru_zay_accept
                                       WHERE     z_id = z.id
                                             AND accept_order =
                                                    DECODE (
                                                       NVL (
                                                          (SELECT MAX (
                                                                     accept_order)
                                                             FROM bud_ru_zay_accept
                                                            WHERE     z_id = z.id
                                                                  AND accepted = 2),
                                                          0),
                                                       0, (SELECT MAX (
                                                                     accept_order)
                                                             FROM bud_ru_zay_accept
                                                            WHERE z_id = z.id),
                                                       (SELECT MAX (accept_order)
                                                          FROM bud_ru_zay_accept
                                                         WHERE     z_id = z.id
                                                               AND accepted = 2)))
                                        current_accepted_id,
                                     st.name st_name,
                                     kat.name kat_name,
                                     (SELECT val_number * 1000
                                        FROM bud_ru_zay_ff
                                       WHERE     ff_id IN (SELECT id
                                                             FROM bud_ru_ff
                                                            WHERE     dpt_id =
                                                                         :dpt_id
                                                                  AND var_name IN ('v3',
                                                                                   'v4'))
                                             AND z_id = z.id)
                                        z_plan,
                                     (SELECT rep_val_number * 1000
                                        FROM bud_ru_zay_ff
                                       WHERE     ff_id IN (SELECT id
                                                             FROM bud_ru_ff
                                                            WHERE     dpt_id =
                                                                         :dpt_id
                                                                  AND rep_var_name IN ('rv3',
                                                                                       'rv4'))
                                             AND z_id = z.id)
                                        z_fakt,
                                     NVL (
                                        (SELECT val_bool
                                           FROM bud_ru_zay_ff
                                          WHERE     ff_id IN (SELECT id
                                                                FROM bud_ru_ff
                                                               WHERE     dpt_id =
                                                                            :dpt_id
                                                                     AND admin_id =
                                                                            8)
                                                AND z_id = z.id),
                                        0)
                                        by_goods,
                                     NVL (
                                        (SELECT val_bool
                                           FROM bud_ru_zay_ff
                                          WHERE     ff_id IN (SELECT id
                                                                FROM bud_ru_ff
                                                               WHERE     dpt_id =
                                                                            :dpt_id
                                                                     AND admin_id =
                                                                            9)
                                                AND z_id = z.id),
                                        0)
                                        via_db
                                FROM bud_ru_zay z,
                                     user_list u,
                                     BUD_RU_st_ras st,
                                     BUD_RU_st_ras kat
                               WHERE     z.tn = u.tn
                                     AND z.st = st.id(+)
                                     AND z.kat = kat.id(+)
                                     AND NVL (kat.la, 0) = 0
                                     AND TRUNC (z.dt_start, 'mm') BETWEEN TO_DATE (
                                                                             :sd,
                                                                             'dd.mm.yyyy')
                                                                      AND TO_DATE (
                                                                             :ed,
                                                                             'dd.mm.yyyy')
                                     AND (   :exp_list_without_ts = 0
                                          OR u.tn IN (SELECT slave
                                                        FROM full
                                                       WHERE master =
                                                                :exp_list_without_ts))
                                     AND (   :exp_list_only_ts = 0
                                          OR u.tn IN (SELECT slave
                                                        FROM full
                                                       WHERE master =
                                                                :exp_list_only_ts))
                                   and u.is_spd=1
  AND (   u.tn IN (SELECT slave
                                                        FROM full
                                                       WHERE master = :tn)
                                          OR (SELECT NVL (is_traid, 0)
                                                FROM user_list
                                               WHERE tn = :tn) = 1
                                          OR (SELECT NVL (is_traid_kk, 0)
                                                FROM user_list
                                               WHERE tn = :tn) = 1)
                                     AND u.tn = DECODE ( :db, 0, u.tn, :db)
                                     AND z.funds =
                                            DECODE ( :funds, 0, z.funds, :funds)
                                     AND z.valid_no = 0
                                     AND DECODE ( :st, 0, z.st, :st) = z.st) z
                       WHERE current_accepted_id = 1 AND deleted = 0
                    ORDER BY period,
                             fil,
                             st_name,
                             z.id)
          GROUP BY fil_id, period) zay,
         (  SELECT fil_id,
                   period,
                   SUM (c) c,
                   SUM (summa) summa,
                   SUM (bonus_sum) bonus_sum,
                   SUM (compens_distr) compens_distr,
                   SUM (compens_db) compens_db,
                   SUM (fakt_distr) fakt_distr
              FROM (  SELECT z.id,
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
                             t.fakt_distr,
                             f.name fil_name,
                             zff1.val_string,
                             zff2.val_textarea,
                             zff3.rep_val_number * 1000 bonus_tma,
                             t.period,
                             (SELECT mt || ' ' || y
                                FROM calendar
                               WHERE data = t.period)
                                period_text
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
                                       SUM (t.bonus_sum) bonus_sum,
                                         SUM (t.bonus_sum)
                                       * CASE
                                            WHEN NVL (
                                                    (SELECT val_bool
                                                       FROM bud_ru_zay_ff
                                                      WHERE     ff_id IN (SELECT id
                                                                            FROM bud_ru_ff
                                                                           WHERE     dpt_id =
                                                                                        :dpt_id
                                                                                 AND admin_id =
                                                                                        9)
                                                            AND z_id = z.id),
                                                    0) = 1
                                            THEN
                                               0
                                            WHEN NVL (
                                                    (SELECT val_bool
                                                       FROM bud_ru_zay_ff
                                                      WHERE     ff_id IN (SELECT id
                                                                            FROM bud_ru_ff
                                                                           WHERE     dpt_id =
                                                                                        :dpt_id
                                                                                 AND admin_id =
                                                                                        8)
                                                            AND z_id = z.id),
                                                    0) = 0
                                            THEN
                                               1
                                            ELSE
                                                 (  1
                                                  -   NVL (
                                                         (SELECT discount
                                                            FROM bud_fil_discount_body
                                                           WHERE     dt =
                                                                        TRUNC (
                                                                           z.dt_start,
                                                                           'mm')
                                                                 AND distr = z.fil),
                                                         0)
                                                    / 100)
                                               * (SELECT bonus_log_koef
                                                    FROM bud_fil
                                                   WHERE id = z.fil)
                                         END
                                          compens_distr,
                                         SUM (t.bonus_sum)
                                       * CASE
                                            WHEN NVL (
                                                    (SELECT val_bool
                                                       FROM bud_ru_zay_ff
                                                      WHERE     ff_id IN (SELECT id
                                                                            FROM bud_ru_ff
                                                                           WHERE     dpt_id =
                                                                                        :dpt_id
                                                                                 AND admin_id =
                                                                                        9)
                                                            AND z_id = z.id),
                                                    0) = 1
                                            THEN
                                               1
                                         END
                                          compens_db,
                                       SUM (t.bonus_sum) fakt_distr,
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
                                               AND m.dt BETWEEN TO_DATE (
                                                                   :sd,
                                                                   'dd.mm.yyyy')
                                                            AND TO_DATE (
                                                                   :ed,
                                                                   'dd.mm.yyyy')) s,
                                       akcii_local_tp t,
                                       bud_ru_zay z
                                 WHERE     s.tp_kod = t.tp_kod
                                       AND t.z_id = z.id
                                       AND (:eta_list IS NULL OR :eta_list = s.h_eta)
                                       AND DECODE ( :fil, 0, z.fil, :fil) = z.fil
                                       AND z.funds =
                                              DECODE ( :funds, 0, z.funds, :funds)
                                       AND (   z.fil IN (SELECT fil_id
                                                           FROM clusters_fils
                                                          WHERE :clusters =
                                                                   CLUSTER_ID)
                                            OR :clusters = 0)
                                       AND s.dt = TRUNC (z.dt_start, 'mm')
                              GROUP BY z.id, z.fil, z.dt_start) t
                       WHERE     t.id = z.id
                             AND z.id_net = n.id_net(+)
                             AND z.fil = f.id
                             AND z.funds = fu.id
                             AND z.funds = DECODE ( :funds, 0, z.funds, :funds)
                             AND z.tn = u.tn
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
                                                        WHERE     z_id = z.id
                                                              AND accepted = 2),
                                                      0),
                                                   0, (SELECT MAX (accept_order)
                                                         FROM bud_ru_zay_accept
                                                        WHERE z_id = z.id),
                                                   (SELECT MAX (accept_order)
                                                      FROM bud_ru_zay_accept
                                                     WHERE     z_id = z.id
                                                           AND accepted = 2))) = 1
                             AND z.valid_no = 0
                             AND TRUNC (z.dt_start, 'mm') BETWEEN TO_DATE (
                                                                     :sd,
                                                                     'dd.mm.yyyy')
                                                              AND TO_DATE (
                                                                     :ed,
                                                                     'dd.mm.yyyy')
                             AND u.tn = DECODE ( :db, 0, u.tn, :db)
                             AND (   :exp_list_without_ts = 0
                                  OR u.tn IN (SELECT slave
                                                FROM full
                                               WHERE master = :exp_list_without_ts))
                             AND (   :exp_list_only_ts = 0
                                  OR u.tn IN (SELECT slave
                                                FROM full
                                               WHERE master = :exp_list_only_ts))
                          and u.is_spd=1
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
                             AND TRUNC (z.dt_start, 'mm') = t.period
                    ORDER BY t.period, val_string, fil_name)
          GROUP BY fil_id, period) act_local,
         (  SELECT fil_id,
                   period,
                   SUM (sales) sales,
                   SUM (tp) tp,
                   SUM (bonus) bonus,
                   SUM (compens_distr) compens_distr,
                   SUM (fakt_distr) fakt_distr
              FROM (  SELECT zp.fil fil_id,
                             z.act,
                             z.act_name,
                             TO_CHAR (z.act_month, 'dd.mm.yyyy') act_month,
                             TO_NUMBER (TO_CHAR (z.act_month, 'mm')) month,
                             SUM (s.tp) tp,
                             SUM (s.sales) sales,
                             SUM (s.bonus) bonus,
                             SUM (
                                  s.bonus
                                * (  1
                                   -   NVL (
                                          (SELECT discount
                                             FROM bud_fil_discount_body
                                            WHERE     dt = z.act_month
                                                  AND distr = zp.fil),
                                          0)
                                     / 100)
                                * (SELECT bonus_log_koef
                                     FROM bud_fil
                                    WHERE id = zp.fil))
                                compens_distr,
                             SUM (s.bonus) fakt_distr,
                             z.act_month period,
                             (SELECT mt || ' ' || y
                                FROM calendar
                               WHERE data = z.act_month)
                                period_text
                        FROM bud_act_fund z,
                             act_svod s,
                             user_list u,
                             (SELECT dt, fil, h_eta
                                FROM bud_svod_zp
                               WHERE     dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                                AND TO_DATE ( :ed, 'dd.mm.yyyy')
                                     AND dpt_id = :dpt_id
                                     AND fil IS NOT NULL) zp
                       WHERE     u.tab_num = s.ts_tab_num
                             AND u.dpt_id = :dpt_id
                          and u.is_spd=1
   AND s.dpt_id = :dpt_id
                             AND s.db_tn = DECODE ( :db, 0, s.db_tn, :db)
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
                             AND (:eta_list IS NULL OR :eta_list = s.h_fio_eta)
                             AND zp.h_eta = s.h_fio_eta
                             AND DECODE ( :fil, 0, zp.fil, :fil) = zp.fil
                             AND z.fund_id = DECODE ( :funds, 0, z.fund_id, :funds)
                             AND (   zp.fil IN (SELECT fil_id
                                                  FROM clusters_fils
                                                 WHERE :clusters = CLUSTER_ID)
                                  OR :clusters = 0)
                             AND z.act = s.act
                             AND TO_NUMBER (TO_CHAR (z.act_month, 'mm')) = s.m
                             AND z.act_month BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                                 AND TO_DATE ( :ed, 'dd.mm.yyyy')
                             AND z.act_month = zp.dt
                             AND DECODE ( :st, 0, 0, 1) = 0
                    GROUP BY zp.fil,
                             z.act,
                             z.act_name,
                             z.act_month
                    ORDER BY z.act_month, z.act_name)
          GROUP BY fil_id, period) act,
         (  SELECT zp.fil fil_id,
                   s.dt period,
                   SUM (
                        (NVL (sv.bonus_fakt, 0) + NVL (sv.fixed_fakt, 0))
                      * CASE
                           WHEN NVL (sv.cash, 0) = 1
                           THEN
                              1
                           ELSE
                                (  1
                                 -   NVL ( (SELECT discount
                                              FROM bud_fil_discount_body
                                             WHERE dt = s.dt AND distr = zp.fil),
                                          0)
                                   / 100)
                              * (SELECT bonus_log_koef
                                   FROM bud_fil
                                  WHERE id = zp.fil)
                        END)
                      compens_distr,
                   SUM (NVL (sv.bonus_fakt, 0) + NVL (sv.fixed_fakt, 0))
                      fakt_distr,
                   SUM (s.summskidka) skidka_val
              FROM (SELECT m.tab_num,
                           m.tp_kod,
                           m.y,
                           m.m,
                           m.summa,
                           m.h_eta,
                           m.eta,
                           m.summskidka,
                           m.bedt_summ,
                           m.tp_type,
                           m.tp_ur,
                           m.tp_addr,
                           m.dt
                      FROM a14mega m
                     WHERE     m.dpt_id = :dpt_id
                           AND m.dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                        AND TO_DATE ( :ed, 'dd.mm.yyyy')) s,
                   user_list u,
                   sc_tp t,
                   sc_svod sv,
                   (SELECT dt, fil, h_eta
                      FROM bud_svod_zp
                     WHERE     dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                      AND TO_DATE ( :ed, 'dd.mm.yyyy')
                           AND dpt_id = :dpt_id
                           AND fil IS NOT NULL) zp
             WHERE     s.tab_num = u.tab_num
                   AND u.dpt_id = :dpt_id
             and u.is_spd=1
      AND :dpt_id = t.dpt_id(+)
                   AND s.tp_kod = t.tp_kod(+)
                   AND s.tp_kod = sv.tp_kod(+)
                   AND sv.dt(+) = s.dt
                   AND :dpt_id = sv.dpt_id(+)
                   AND (   discount > 0
                        OR bonus > 0
                        OR fixed > 0
                        OR margin > 0
                        OR sv.bonus_fakt > 0
                        OR sv.fixed_fakt > 0)
                   AND zp.h_eta = s.h_eta
                   AND s.dt = zp.dt
                   AND (SELECT COUNT (*)
                          FROM bud_funds
                         WHERE dpt_id = :dpt_id AND id = :funds AND kod = 'svs') <>
                          0
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
          GROUP BY zp.fil, s.dt) svs,
         (  SELECT dt period,
                   fil fil_id,
                   SUM (total) fakt_distr,
                   SUM (compens_distr) compens_distr,
                   -SUM (skidka_val) skidka_val
              FROM (SELECT s.dt,
                           zp.fil,
                           NVL (sv.bonus_fakt, 0) + NVL (sv.fixed_fakt, 0) total,
                           -s.summskidka skidka_val,
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
                                               WHERE dt = s.dt AND distr = zp.fil),
                                             0)
                                        / 100)
                                   * (SELECT bonus_log_koef
                                        FROM bud_fil
                                       WHERE id = zp.fil)
                             END
                              compens_distr
                      FROM a14mega s,
                           user_list u,
                           (SELECT DISTINCT
                                   TO_NUMBER (
                                      getZayFieldVal (z.id, 'admin_id', 4))
                                      tp_kod
                              FROM bud_ru_zay z, user_list u
                             WHERE     (SELECT NVL (tu, 0)
                                          FROM bud_ru_st_ras
                                         WHERE id = z.kat) = 1
                                   AND z.tn = u.tn
                                   AND u.dpt_id = :dpt_id
                                   AND TRUNC (z.dt_end, 'mm') >=
                                          TO_DATE ( :sd, 'dd.mm.yyyy')
                                   AND TRUNC (z.dt_start, 'mm') <=
                                          TO_DATE ( :ed, 'dd.mm.yyyy')
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
                                          getZayFieldVal (z.id, 'admin_id', 4))
                                          IS NOT NULL) t,
                           sc_svodn sv,
                           bud_svod_zp zp
                     WHERE     s.dt = sv.dt(+)
                           AND s.dpt_id = :dpt_id
                           AND s.dt = zp.dt(+)
                           AND zp.dpt_id(+) = :dpt_id
                           AND s.tab_num = u.tab_num
                           AND u.dpt_id = :dpt_id
                      and u.is_spd=1
     AND s.tp_kod = t.tp_kod
                           AND s.tp_kod = sv.tp_kod(+)
                           AND sv.dt(+) = s.dt
                           AND s.dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                        AND TO_DATE ( :ed, 'dd.mm.yyyy')
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
                           AND (:eta_list IS NULL OR :eta_list = s.h_eta)
                           AND zp.h_eta = s.h_eta
                           AND (zp.fil = :fil OR :fil = 0)
                           AND (   zp.fil IN (SELECT fil_id
                                                FROM clusters_fils
                                               WHERE :clusters = CLUSTER_ID)
                                OR :clusters = 0)
                           AND (SELECT COUNT (*)
                                  FROM bud_funds
                                 WHERE     dpt_id = :dpt_id
                                       AND id = :funds
                                       AND kod = 'svs') <> 0
                    UNION
                      SELECT s.dt,
                             s.fil,
                               NVL (SUM (sv.bonus_fakt), 0)
                             + NVL (SUM (sv.fixed_fakt), 0)
                                total,
                             SUM (skidka_val) skidka_val,
                             SUM (
                                  (NVL (sv.bonus_fakt, 0) + NVL (sv.fixed_fakt, 0))
                                * CASE
                                     WHEN NVL (sv.cash, 0) = 1 THEN 1
                                     ELSE s.compens_distr_koef
                                  END)
                                compens_distr
                        FROM (  SELECT s.dt,
                                       s.dpt_id,
                                       s.net_kod,
                                       s.db,
                                       s.fil,
                                       -SUM (s.summskidka) skidka_val,
                                         (  1
                                          -   NVL (
                                                 (SELECT discount
                                                    FROM bud_fil_discount_body
                                                   WHERE dt = s.dt AND distr = s.fil),
                                                 0)
                                            / 100)
                                       * (SELECT bonus_log_koef
                                            FROM bud_fil
                                           WHERE id = s.fil)
                                          compens_distr_koef
                                  FROM (SELECT tpn.net_kod,
                                               u.tn,
                                               p.parent db,
                                               m.h_eta,
                                               m.summskidka,
                                               f.id fil,
                                               m.dt,
                                               m.dpt_id
                                          FROM a14mega m,
                                               user_list u,
                                               parents p,
                                               tp_nets tpn,
                                               bud_fil f,
                                               bud_tn_fil tf
                                         WHERE     m.tp_kod = tpn.tp_kod
                                          and u.is_spd=1
     AND u.tn = p.tn
                                               AND u.tab_num = m.tab_num
                                               AND u.dpt_id = m.dpt_id
                                               AND f.id = tf.bud_id
                                               AND tf.tn = p.parent
                                               AND f.dpt_id = m.dpt_id
                                               AND (   f.data_end IS NULL
                                                    OR TRUNC (f.data_end, 'mm') >=
                                                          TO_DATE ( :ed,
                                                                   'dd.mm.yyyy'))) s,
                                       (SELECT DISTINCT
                                               TO_NUMBER (
                                                  getZayFieldVal (z.id,
                                                                  'admin_id',
                                                                  14))
                                                  chain
                                          FROM bud_ru_zay z, user_list u
                                         WHERE     (SELECT NVL (tu, 0)
                                                      FROM bud_ru_st_ras
                                                     WHERE id = z.kat) = 1
                                               AND z.tn = u.tn
                                               AND u.dpt_id = :dpt_id
                                               AND TRUNC (z.dt_end, 'mm') >=
                                                      TO_DATE ( :sd, 'dd.mm.yyyy')
                                               AND TRUNC (z.dt_start, 'mm') <=
                                                      TO_DATE ( :ed, 'dd.mm.yyyy')
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
                                                                       WHERE     z_id =
                                                                                    z.id
                                                                             AND rep_accepted =
                                                                                    2))) =
                                                      1
                                               AND TO_NUMBER (
                                                      getZayFieldVal (z.id,
                                                                      'admin_id',
                                                                      14))
                                                      IS NOT NULL) t,
                                       (SELECT fil,
                                               h_eta,
                                               dt,
                                               dpt_id
                                          FROM bud_svod_zp
                                         WHERE fil IS NOT NULL) zp
                                 WHERE     s.dt = zp.dt(+)
                                       AND zp.dpt_id(+) = :dpt_id
                                       AND s.net_kod = t.chain
                                       AND s.fil = zp.fil(+)
                                       AND (   :exp_list_without_ts = 0
                                            OR s.tn IN (SELECT slave
                                                          FROM full
                                                         WHERE master =
                                                                  :exp_list_without_ts))
                                       AND (   :exp_list_only_ts = 0
                                            OR s.tn IN (SELECT slave
                                                          FROM full
                                                         WHERE master =
                                                                  :exp_list_only_ts))
                                       AND (   s.tn IN (SELECT slave
                                                          FROM full
                                                         WHERE master = :tn)
                                            OR (SELECT NVL (is_traid, 0)
                                                  FROM user_list
                                                 WHERE tn = :tn) = 1
                                            OR (SELECT NVL (is_traid_kk, 0)
                                                  FROM user_list
                                                 WHERE tn = :tn) = 1)
                                       AND (:eta_list IS NULL OR :eta_list = s.h_eta)
                                       AND zp.h_eta = s.h_eta
                                       AND (zp.fil = :fil OR :fil = 0)
                                       AND (   zp.fil IN (SELECT fil_id
                                                            FROM clusters_fils
                                                           WHERE :clusters =
                                                                    CLUSTER_ID)
                                            OR :clusters = 0)
                              GROUP BY s.dt,
                                       s.dpt_id,
                                       s.net_kod,
                                       s.fil,
                                       s.db) s,
                             sc_svodn sv
                       WHERE     s.dt = sv.dt(+)
                             AND s.dpt_id = :dpt_id
                             AND s.net_kod = sv.net_kod(+)
                             AND s.fil = sv.fil(+)
                             AND s.db = sv.db(+)
                             AND s.dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                          AND TO_DATE ( :ed, 'dd.mm.yyyy')
                             AND :dpt_id = sv.dpt_id(+)
                             AND (SELECT COUNT (*)
                                    FROM bud_funds
                                   WHERE     dpt_id = :dpt_id
                                         AND id = :funds
                                         AND kod = 'svs') <> 0
                    GROUP BY s.dt, s.fil)
          GROUP BY dt, fil) svs_new
   WHERE     tf.fil_id = zay.fil_id(+)
         AND tf.fil_id = act_local.fil_id(+)
         AND tf.fil_id = act.fil_id(+)
         AND tf.fil_id = svs.fil_id(+)
         AND tf.fil_id = svs_new.fil_id(+)
         AND tf.period = zay.period(+)
         AND tf.period = act_local.period(+)
         AND tf.period = act.period(+)
         AND tf.period = svs.period(+)
         AND tf.period = svs_new.period(+)
ORDER BY tf.period, tf.name)
GROUP BY fil_id, name