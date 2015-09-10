/* Formatted on 28/07/2015 14:50:23 (QP5 v5.227.12220.39724) */
SELECT SUM (sales_fact) sales_fact,
       SUM (svs_total) svs_total,
       SUM (zp_total) zp_total,
       SUM (gsm_total) gsm_total,
       SUM (promo_total) promo_total,
       SUM (zay_compens_db) zay_compens_db
  FROM (  SELECT x.fil_id,
                 x.fil_name,
                 SUM (x.sales_fact) / COUNT (DISTINCT x.fund_id) sales_fact,
                 SUM (
                    CASE WHEN x.fnd_kod = 'svs' THEN x.svs_total ELSE NULL END)
                    svs_total,
                 SUM (CASE WHEN x.fnd_kod = 'zp' THEN x.zp_total ELSE NULL END)
                    zp_total,
                 SUM (
                    CASE WHEN x.fnd_kod = 'gbo' THEN x.gsm_total ELSE NULL END)
                    gsm_total,
                 SUM (
                    CASE
                       WHEN x.fnd_kod = 'prm' THEN x.promo_total
                       ELSE NULL
                    END)
                    promo_total,
                 SUM (x.zay_compens_db) zay_compens_db,
                 x.prot_db,
                 x.ok_db_tn,
                 x.ok_t1_tn,
                 x.ok_pr_tn,
                 x.ok_t2_tn,
                 x.ok_db_lu,
                 x.ok_t1_lu,
                 x.ok_pr_lu,
                 x.ok_t2_lu,
                 x.ok_db_fio,
                 x.ok_t1_fio,
                 x.ok_pr_fio,
                 x.ok_t2_fio,
                 (SELECT master
                    FROM full
                   WHERE slave = x.ok_db_tn AND full = 1)
                    tn_pr,
                 (SELECT master
                    FROM full
                   WHERE     slave = (SELECT master
                                        FROM full
                                       WHERE slave = x.ok_db_tn AND full = 1)
                         AND full = 1)
                    tn_vr
            FROM (  SELECT tf.fil_id,
                           tf.fil_name,
                           tf.fund_id,
                           tf.fund_name,
                           sales.cust_name,
                           sales.sales_fact,
                           tf.norm,
                           tf.fnd_kod,
                           sales.sales_fact * tf.norm / 100 sales_fact_perc_norm,
                           sales.sales_fact * (tf.norm - 0.5) / 100
                              sales_fact_perc_norm05,
                           sales.sales_fact * 0.5 / 100 sales_fact_perc_05,
                           sales.sales_price,
                           sales.skid_nacenka,
                           sales.sales_2_5,
                           sales.dop_zarobotok,
                           zay.z_plan,
                           zay.z_fakt,
                           act.compens_distr act_compens_distr,
                           act_local.compens_distr act_local_compens_distr,
                           zay.compens_distr zay_compens_distr,
                           zay.compens_db zay_compens_db,
                             NVL (act.compens_distr, 0)
                           + NVL (act_local.compens_distr, 0)
                           + NVL (zay.compens_distr, 0)
                              promo_total,
                           svs.compens_distr svs_compens_distr,
                             NVL (svs.compens_distr, 0)
                           + NVL (zay.compens_distr, 0)
                           + NVL (act_local.compens_distr, 0)
                           + NVL (act.compens_distr, 0)
                              svs_total,
                           zp.sum_zp zp_total,
                           zp.total1 gsm_total,
                           taf.prot_db,
                           taf.ok_db_tn,
                           taf.ok_t1_tn,
                           taf.ok_pr_tn,
                           taf.ok_t2_tn,
                           taf.ok_db_lu,
                           taf.ok_t1_lu,
                           taf.ok_pr_lu,
                           taf.ok_t2_lu,
                           taf.ok_db_fio,
                           taf.ok_t1_fio,
                           taf.ok_pr_fio,
                           taf.ok_t2_fio
                      FROM (  SELECT f.id fil_id,
                                     f.name fil_name,
                                     f.sw_kod,
                                     tf.bud_id,
                                     fnd.id fund_id,
                                     fnd.name fund_name,
                                     n.norm,
                                     f.gsm,
                                     fnd.kod fnd_kod
                                FROM bud_fil f,
                                     bud_funds fnd,
                                     bud_tn_fil tf,
                                     user_list u,
                                     bud_funds_norm n
                               WHERE     f.id = tf.bud_id
                                     AND f.dpt_id = :dpt_id
                                     AND (   f.data_end IS NULL
                                          OR TRUNC (f.data_end, 'mm') >=
                                                TO_DATE (:dt, 'dd.mm.yyyy'))
                                     AND DECODE (:fil, 0, f.id, :fil) = f.id
                                     AND (   f.id IN
                                                (SELECT fil_id
                                                   FROM clusters_fils
                                                  WHERE :clusters = CLUSTER_ID)
                                          OR :clusters = 0)
                                     AND u.tn IN
                                            (SELECT slave
                                               FROM full
                                              WHERE master =
                                                       DECODE (
                                                          :exp_list_without_ts,
                                                          0, master,
                                                          :exp_list_without_ts))
                                     AND u.tn = DECODE (:db, 0, u.tn, :db)
                                     AND (   u.tn IN (SELECT slave
                                                        FROM full
                                                       WHERE master = :tn)
                                          OR (SELECT NVL (is_traid, 0)
                                                FROM user_list
                                               WHERE tn = :tn) = 1
                                          OR (SELECT NVL (is_traid_kk, 0)
                                                FROM user_list
                                               WHERE tn = :tn) = 1)
                                     AND fnd.dpt_id = :dpt_id
                                     AND u.tn = tf.tn
                                     AND TO_DATE (:dt, 'dd.mm.yyyy') = n.dt(+)
                                     AND n.fund(+) = fnd.id
                            GROUP BY f.id,
                                     f.name,
                                     tf.bud_id,
                                     fnd.id,
                                     fnd.name,
                                     f.sw_kod,
                                     n.norm,
                                     f.gsm,
                                     fnd.kod) tf,
                           (  SELECT z.fil,
                                     z.funds,
                                     SUM (z_plan) z_plan,
                                     SUM (z_fakt) z_fakt,
                                     SUM (
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
                                                                WHERE     dt =
                                                                             TO_DATE (
                                                                                :dt,
                                                                                'dd.mm.yyyy')
                                                                      AND distr =
                                                                             z.fil),
                                                              0)
                                                         / 100)
                                                    * (SELECT bonus_log_koef
                                                         FROM bud_fil
                                                        WHERE id = z.fil)
                                              END
                                        END)
                                        compens_distr,
                                     SUM (
                                        CASE
                                           WHEN via_db = 1 THEN z_fakt
                                           ELSE NULL
                                        END)
                                        compens_db
                                FROM (SELECT z.*,
                                             DECODE (
                                                (SELECT COUNT (*)
                                                   FROM bud_ru_zay_accept
                                                  WHERE     z_id = z.id
                                                        AND accepted = 2),
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
                                                                    WHERE     z_id =
                                                                                 z.id
                                                                          AND accepted =
                                                                                 2),
                                                                  0),
                                                               0, (SELECT MAX (
                                                                             accept_order)
                                                                     FROM bud_ru_zay_accept
                                                                    WHERE z_id =
                                                                             z.id),
                                                               (SELECT MAX (
                                                                          accept_order)
                                                                  FROM bud_ru_zay_accept
                                                                 WHERE     z_id =
                                                                              z.id
                                                                       AND accepted =
                                                                              2)))
                                                current_accepted_id,
                                             st.name st_name,
                                             kat.name kat_name,
                                             (SELECT val_number * 1000
                                                FROM bud_ru_zay_ff
                                               WHERE     ff_id IN
                                                            (SELECT id
                                                               FROM bud_ru_ff
                                                              WHERE     dpt_id =
                                                                           :dpt_id
                                                                    AND var_name IN
                                                                           ('v3',
                                                                            'v4'))
                                                     AND z_id = z.id)
                                                z_plan,
                                             (SELECT rep_val_number * 1000
                                                FROM bud_ru_zay_ff
                                               WHERE     ff_id IN
                                                            (SELECT id
                                                               FROM bud_ru_ff
                                                              WHERE     dpt_id =
                                                                           :dpt_id
                                                                    AND rep_var_name IN
                                                                           ('rv3',
                                                                            'rv4'))
                                                     AND z_id = z.id)
                                                z_fakt,
                                             NVL (
                                                (SELECT val_bool
                                                   FROM bud_ru_zay_ff
                                                  WHERE     ff_id IN
                                                               (SELECT id
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
                                                  WHERE     ff_id IN
                                                               (SELECT id
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
                                             bud_ru_st_ras st,
                                             bud_ru_st_ras kat
                                       WHERE     z.tn = u.tn
                                             AND z.st = st.id(+)
                                             AND z.kat = kat.id(+)
                                             AND NVL (kat.la, 0) = 0
                                             AND TRUNC (z.dt_start, 'mm') =
                                                    TO_DATE (:dt, 'dd.mm.yyyy')
                                             AND z.valid_no = 0
                                             AND u.tn IN
                                                    (SELECT slave
                                                       FROM full
                                                      WHERE master =
                                                               DECODE (
                                                                  :exp_list_without_ts,
                                                                  0, master,
                                                                  :exp_list_without_ts))
                                             AND (   u.tn IN (SELECT slave
                                                                FROM full
                                                               WHERE master = :tn)
                                                  OR (SELECT NVL (is_traid, 0)
                                                        FROM user_list
                                                       WHERE tn = :tn) = 1
                                                  OR (SELECT NVL (is_traid_kk, 0)
                                                        FROM user_list
                                                       WHERE tn = :tn) = 1)
                                             AND u.tn = DECODE (:db, 0, u.tn, :db)) z
                               WHERE current_accepted_id = 1 AND deleted = 0
                            GROUP BY z.fil, z.funds) zay,
                           (  SELECT z.fil,
                                     z.funds,
                                     SUM (t.compens_distr) compens_distr
                                FROM bud_ru_zay z,
                                     user_list u,
                                     bud_ru_st_ras st,
                                     bud_ru_st_ras kat,
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
                                                              WHERE     ff_id IN
                                                                           (SELECT id
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
                                                                                TO_DATE (
                                                                                   :dt,
                                                                                   'dd.mm.yyyy')
                                                                         AND distr =
                                                                                z.fil),
                                                                 0)
                                                            / 100)
                                                       * (SELECT bonus_log_koef
                                                            FROM bud_fil
                                                           WHERE id = z.fil)
                                                 END
                                                  compens_distr
                                          FROM (SELECT m.tab_num,
                                                       m.tp_kod,
                                                       m.y,
                                                       m.m,
                                                       m.summa,
                                                       m.h_eta,
                                                       m.eta
                                                  FROM a14mega m
                                                 WHERE     m.dpt_id = :dpt_id
                                                       AND m.dt =
                                                              TO_DATE (:dt,
                                                                       'dd.mm.yyyy')) s,
                                               akcii_local_tp t,
                                               bud_ru_zay z
                                         WHERE s.tp_kod = t.tp_kod AND t.z_id = z.id
                                      GROUP BY z.id, z.fil) t
                               WHERE     t.id = z.id
                                     AND z.id_net = n.id_net(+)
                                     AND z.fil = f.id
                                     AND z.funds = fu.id
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
                                                              (SELECT MAX (
                                                                         accept_order)
                                                                 FROM bud_ru_zay_accept
                                                                WHERE     z_id =
                                                                             z.id
                                                                      AND accepted =
                                                                             2),
                                                              0),
                                                           0, (SELECT MAX (
                                                                         accept_order)
                                                                 FROM bud_ru_zay_accept
                                                                WHERE z_id = z.id),
                                                           (SELECT MAX (
                                                                      accept_order)
                                                              FROM bud_ru_zay_accept
                                                             WHERE     z_id = z.id
                                                                   AND accepted =
                                                                          2))) =
                                            1
                                     AND z.valid_no = 0
                                     AND TRUNC (z.dt_start, 'mm') =
                                            TO_DATE (:dt, 'dd.mm.yyyy')
                                     AND u.tn IN
                                            (SELECT slave
                                               FROM full
                                              WHERE master =
                                                       DECODE (
                                                          :exp_list_without_ts,
                                                          0, master,
                                                          :exp_list_without_ts))
                                     AND (   u.tn IN (SELECT slave
                                                        FROM full
                                                       WHERE master = :tn)
                                          OR (SELECT NVL (is_traid, 0)
                                                FROM user_list
                                               WHERE tn = :tn) = 1
                                          OR (SELECT NVL (is_traid_kk, 0)
                                                FROM user_list
                                               WHERE tn = :tn) = 1)
                                     AND u.tn = DECODE (:db, 0, u.tn, :db)
                            GROUP BY z.fil, z.funds) act_local,
                           (  SELECT zp.fil,
                                     z.fund_id,
                                     SUM (s.sales) sales,
                                     SUM (s.bonus) bonus,
                                       SUM (s.bonus)
                                     * (  1
                                        -   NVL (
                                               (SELECT discount
                                                  FROM bud_fil_discount_body
                                                 WHERE     dt =
                                                              TO_DATE (
                                                                 :dt,
                                                                 'dd.mm.yyyy')
                                                       AND distr = zp.fil),
                                               0)
                                          / 100)
                                     * (SELECT bonus_log_koef
                                          FROM bud_fil
                                         WHERE id = zp.fil)
                                        compens_distr
                                FROM bud_act_fund z,
                                     act_svod s,
                                     user_list u,
                                     (SELECT fil, h_eta
                                        FROM bud_svod_zp
                                       WHERE     dt = TO_DATE (:dt, 'dd.mm.yyyy')
                                             AND dpt_id = :dpt_id
                                             AND fil IS NOT NULL) zp
                               WHERE     u.tab_num = s.ts_tab_num
                                     AND u.dpt_id = :dpt_id
                                     AND s.dpt_id = :dpt_id
                                     AND zp.h_eta = s.h_fio_eta
                                     AND DECODE (:fil, 0, zp.fil, :fil) = zp.fil
                                     AND (   zp.fil IN
                                                (SELECT fil_id
                                                   FROM clusters_fils
                                                  WHERE :clusters = CLUSTER_ID)
                                          OR :clusters = 0)
                                     AND z.act = s.act
                                     AND TO_NUMBER (TO_CHAR (z.act_month, 'mm')) =
                                            s.m
                                     AND z.act_month = TO_DATE (:dt, 'dd.mm.yyyy')
                                     AND u.tn IN
                                            (SELECT slave
                                               FROM full
                                              WHERE master =
                                                       DECODE (
                                                          :exp_list_without_ts,
                                                          0, master,
                                                          :exp_list_without_ts))
                                     AND (   u.tn IN (SELECT slave
                                                        FROM full
                                                       WHERE master = :tn)
                                          OR (SELECT NVL (is_traid, 0)
                                                FROM user_list
                                               WHERE tn = :tn) = 1
                                          OR (SELECT NVL (is_traid_kk, 0)
                                                FROM user_list
                                               WHERE tn = :tn) = 1)
                                     AND s.db_tn = DECODE (:db, 0, s.db_tn, :db)
                            GROUP BY zp.fil, z.fund_id) act,
                           (SELECT cust_id,
                                   cust_name,
                                   sales_fact * 1000 sales_fact,
                                   sales_price * 1000 sales_price,
                                   skid_nacenka * 100 skid_nacenka,
                                   sales_2_5 * 1000 sales_2_5,
                                   dop_zarobotok * 1000 dop_zarobotok
                              FROM sales_nac_by_distr_2014
                             WHERE dt = TO_DATE (:dt, 'dd.mm.yyyy')) sales,
                           (  SELECT zp.fil,
                                     SUM (
                                          (  NVL (sv.bonus_fakt, 0)
                                           + NVL (sv.fixed_fakt, 0))
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
                                                                         TO_DATE (
                                                                            :dt,
                                                                            'dd.mm.yyyy')
                                                                  AND distr =
                                                                         zp.fil),
                                                          0)
                                                     / 100)
                                                * (SELECT bonus_log_koef
                                                     FROM bud_fil
                                                    WHERE id = zp.fil)
                                          END)
                                        compens_distr
                                FROM (SELECT m.tab_num,
                                             m.tp_kod,
                                             m.y,
                                             m.m,
                                             m.summa,
                                             m.h_eta,
                                             m.eta,
                                             m.skidka,
                                             m.bedt_summ,
                                             m.tp_type,
                                             m.tp_ur,
                                             m.tp_addr
                                        FROM a14mega m
                                       WHERE     m.dpt_id = :dpt_id
                                             AND m.dt = TO_DATE (:dt, 'dd.mm.yyyy')) s,
                                     user_list u,
                                     sc_tp t,
                                     sc_svod sv,
                                     (SELECT fil, h_eta
                                        FROM bud_svod_zp
                                       WHERE     dt = TO_DATE (:dt, 'dd.mm.yyyy')
                                             AND dpt_id = :dpt_id
                                             AND fil IS NOT NULL) zp
                               WHERE     s.tab_num = u.tab_num
                                     AND u.dpt_id = :dpt_id
                                     AND :dpt_id = t.dpt_id(+)
                                     AND s.tp_kod = t.tp_kod(+)
                                     AND s.tp_kod = sv.tp_kod(+)
                                     AND sv.dt(+) = TO_DATE (:dt, 'dd.mm.yyyy')
                                     AND :dpt_id = sv.dpt_id(+)
                                     AND (   discount > 0
                                          OR bonus > 0
                                          OR fixed > 0
                                          OR margin > 0)
                                     AND zp.h_eta = s.h_eta
                                     AND u.tn IN
                                            (SELECT slave
                                               FROM full
                                              WHERE master =
                                                       DECODE (
                                                          :exp_list_without_ts,
                                                          0, master,
                                                          :exp_list_without_ts))
                                     AND (   u.tn IN (SELECT slave
                                                        FROM full
                                                       WHERE master = :tn)
                                          OR (SELECT NVL (is_traid, 0)
                                                FROM user_list
                                               WHERE tn = :tn) = 1
                                          OR (SELECT NVL (is_traid_kk, 0)
                                                FROM user_list
                                               WHERE tn = :tn) = 1)
                            GROUP BY zp.fil) svs,
                           (  SELECT f.id fil,
                                     SUM (sv.zp_fakt) sum_zp,
                                     SUM (
                                          NVL (sv.fal_payment, 0)
                                        + NVL (sv.amort, 0)
                                        + NVL (sv.gbo_warmup, 0))
                                        total1
                                FROM bud_svod_zp sv, bud_fil f
                               WHERE     sv.fil = f.id
                                     AND TO_DATE (:dt, 'dd.mm.yyyy') = sv.dt
                            GROUP BY f.id) zp,
                           (SELECT fil,
                                   prot_db,
                                   ok_db_tn,
                                   ok_t1_tn,
                                   ok_pr_tn,
                                   ok_t2_tn,
                                   TO_CHAR (ok_db_lu, 'dd.mm.yyyy hh24:mi:ss')
                                      ok_db_lu,
                                   TO_CHAR (ok_t1_lu, 'dd.mm.yyyy hh24:mi:ss')
                                      ok_t1_lu,
                                   TO_CHAR (ok_pr_lu, 'dd.mm.yyyy hh24:mi:ss')
                                      ok_pr_lu,
                                   TO_CHAR (ok_t2_lu, 'dd.mm.yyyy hh24:mi:ss')
                                      ok_t2_lu,
                                   ok_db_fio,
                                   ok_t1_fio,
                                   ok_pr_fio,
                                   ok_t2_fio
                              FROM bud_svod_taf
                             WHERE dt = TO_DATE (:dt, 'dd.mm.yyyy')) taf
                     WHERE     tf.fil_id = zay.fil(+)
                           AND tf.fil_id = act_local.fil(+)
                           AND tf.fil_id = act.fil(+)
                           AND tf.fund_id = zay.funds(+)
                           AND tf.fund_id = act_local.funds(+)
                           AND tf.fund_id = act.fund_id(+)
                           AND tf.sw_kod = sales.cust_id(+)
                           AND tf.fil_id = svs.fil(+)
                           AND tf.fil_id = zp.fil(+)
                           AND tf.fil_id = taf.fil(+)
                  ORDER BY tf.fil_name, tf.fund_name) x
           WHERE     DECODE (:ok_db, 1, 0, DECODE (x.ok_db_tn, NULL, 0, 1)) =
                        DECODE (:ok_db,  1, 0,  2, 1,  3, 0)
                 AND DECODE (:ok_t1, 1, 0, DECODE (x.ok_t1_tn, NULL, 0, 1)) =
                        DECODE (:ok_t1,  1, 0,  2, 1,  3, 0)
                 AND DECODE (:ok_pr, 1, 0, DECODE (x.ok_pr_tn, NULL, 0, 1)) =
                        DECODE (:ok_pr,  1, 0,  2, 1,  3, 0)
                 AND DECODE (:ok_t2, 1, 0, DECODE (x.ok_t2_tn, NULL, 0, 1)) =
                        DECODE (:ok_t2,  1, 0,  2, 1,  3, 0)
        GROUP BY x.fil_id,
                 x.fil_name,
                 x.prot_db,
                 x.ok_db_tn,
                 x.ok_t1_tn,
                 x.ok_pr_tn,
                 x.ok_t2_tn,
                 x.ok_db_lu,
                 x.ok_t1_lu,
                 x.ok_pr_lu,
                 x.ok_t2_lu,
                 x.ok_db_fio,
                 x.ok_t1_fio,
                 x.ok_pr_fio,
                 x.ok_t2_fio
        ORDER BY x.fil_name)