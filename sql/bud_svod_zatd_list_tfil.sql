/* Formatted on 07.11.2017 18:23:05 (QP5 v5.252.13127.32867) */
  SELECT fil_id,
         fil_name,
         SUM (sales_fact) / COUNT (DISTINCT fund_id) sales_fact,
         SUM (CASE WHEN fnd_kod = 'svs' THEN svs_total ELSE NULL END) svs_total,
         SUM (CASE WHEN fnd_kod = 'zp' THEN zp_total ELSE NULL END) zp_total,
         SUM (CASE WHEN fnd_kod = 'gbo' THEN gsm_total ELSE NULL END) gsm_total,
         SUM (CASE WHEN fnd_kod = 'prm' THEN promo_total ELSE NULL END)
            promo_total,
           SUM (CASE WHEN fnd_kod = 'svs' THEN svs_total ELSE NULL END)
         + SUM (CASE WHEN fnd_kod = 'zp' THEN zp_total ELSE NULL END)
         + SUM (CASE WHEN fnd_kod = 'gbo' THEN gsm_total ELSE NULL END)
         + SUM (CASE WHEN fnd_kod = 'prm' THEN promo_total ELSE NULL END)
            total
    FROM (  SELECT fil_id,
                   fil_name,
                   fund_id,
                   fund_name,
                   fnd_kod,
                   AVG (norm) norm,
                   SUM (sales_fact) sales_fact,
                   SUM (sales_fact_perc_norm) sales_fact_perc_norm,
                   SUM (sales_fact_perc_norm05) sales_fact_perc_norm05,
                   SUM (sales_fact_perc_05) sales_fact_perc_05,
                   SUM (sales_price) sales_price,
                   SUM (skid_nacenka) skid_nacenka,
                   SUM (sales_2_5) sales_2_5,
                   SUM (dop_zarobotok) dop_zarobotok,
                   SUM (z_plan) z_plan,
                   SUM (z_fakt) z_fakt,
                   SUM (act_compens_distr) act_compens_distr,
                   SUM (act_local_compens_distr) act_local_compens_distr,
                   SUM (zay_compens_distr) zay_compens_distr,
                   SUM (compens_db) compens_db,
                   SUM (promo_total) promo_total,
                   SUM (svs_compens_distr) svs_compens_distr,
                   SUM (svs_total) svs_total,
                   SUM (sum_zp) sum_zp,
                   SUM (zp_total) zp_total,
                   SUM (gsm) gsm,
                   SUM (gsm_total1) gsm_total1,
                   SUM (gsm_total) gsm_total,
                   SUM (total) total
              FROM (  SELECT tf.fil_id,
                             tf.fil_name,
                             tf.fund_id,
                             tf.fund_name,
                             tf.period,
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
                             NVL (act_local.compens_db, 0) + NVL (zay.compens_db, 0)
                                compens_db,
                             - (  NVL (act.compens_distr, 0)
                                + NVL (act_local.compens_distr, 0)
                                + NVL (zay.compens_distr, 0))
                                promo_total,
                               NVL (svs.compens_distr, 0)
                             + NVL (svs_new.compens_distr, 0)
                                svs_compens_distr,
                               NVL (sales.dop_zarobotok, 0)
                             - NVL (svs.compens_distr, 0)
                             - NVL (svs_new.compens_distr, 0)
                             - NVL (zay.compens_distr, 0)
                             - NVL (act_local.compens_distr, 0)
                             - NVL (act.compens_distr, 0)
                                svs_total,
                             zp.sum_zp,
                               NVL (sales.sales_fact * tf.norm / 100, 0)
                             - NVL (zp.sum_zp, 0)
                             - NVL (zay.compens_distr, 0)
                                zp_total,
                             tf.gsm,
                             zp.total1 gsm_total1,
                             CASE
                                WHEN tf.gsm = 1
                                THEN
                                   CASE
                                      WHEN (  NVL (
                                                   sales.sales_fact
                                                 * (tf.norm - 0.5)
                                                 / 100,
                                                 0)
                                            - NVL (zp.total1, 0)
                                            - NVL (zay.compens_distr, 0)) > 0
                                      THEN
                                             (  NVL (
                                                     sales.sales_fact
                                                   * (tf.norm - 0.5)
                                                   / 100,
                                                   0)
                                              - NVL (zp.total1, 0)
                                              - NVL (zay.compens_distr, 0))
                                           / 2
                                         + NVL (sales.sales_fact * 0.5 / 100, 0)
                                      ELSE
                                           (  NVL (
                                                   sales.sales_fact
                                                 * (tf.norm - 0.5)
                                                 / 100,
                                                 0)
                                            - NVL (zp.total1, 0)
                                            - NVL (zay.compens_distr, 0))
                                         + NVL (sales.sales_fact * 0.5 / 100, 0)
                                   END
                                WHEN tf.gsm = 2
                                THEN
                                     (  NVL (
                                           sales.sales_fact * (tf.norm - 0.5) / 100,
                                           0)
                                      - NVL (zp.total1, 0)
                                      - NVL (zay.compens_distr, 0))
                                   + NVL (sales.sales_fact * 0.5 / 100, 0)
                                WHEN tf.gsm = 3
                                THEN
                                     (  NVL (
                                           sales.sales_fact * (tf.norm - 0.5) / 100,
                                           0)
                                      - NVL (zp.total1, 0)
                                      - NVL (zay.compens_distr, 0))
                                   + NVL (sales.sales_fact * 0.5 / 100, 0) * 2
                                ELSE
                                   0
                             END
                                gsm_total,
                               CASE
                                  WHEN tf.fnd_kod = 'svs'
                                  THEN
                                       NVL (sales.dop_zarobotok, 0)
                                     - NVL (svs.compens_distr, 0)
                                     - NVL (svs_new.compens_distr, 0)
                                     - NVL (zay.compens_distr, 0)
                                     - NVL (act_local.compens_distr, 0)
                                     - NVL (act.compens_distr, 0)
                                  ELSE
                                     0
                               END
                             + CASE
                                  WHEN tf.fnd_kod = 'zp'
                                  THEN
                                       NVL (sales.sales_fact * tf.norm / 100, 0)
                                     - NVL (zp.sum_zp, 0)
                                     - NVL (zay.compens_distr, 0)
                                  ELSE
                                     0
                               END
                             + CASE
                                  WHEN tf.fnd_kod = 'gbo'
                                  THEN
                                     CASE
                                        WHEN tf.gsm = 1
                                        THEN
                                           CASE
                                              WHEN (  NVL (
                                                           sales.sales_fact
                                                         * (tf.norm - 0.5)
                                                         / 100,
                                                         0)
                                                    - NVL (zp.total1, 0)
                                                    - NVL (zay.compens_distr, 0)) > 0
                                              THEN
                                                     (  NVL (
                                                             sales.sales_fact
                                                           * (tf.norm - 0.5)
                                                           / 100,
                                                           0)
                                                      - NVL (zp.total1, 0)
                                                      - NVL (zay.compens_distr, 0))
                                                   / 2
                                                 + NVL (sales.sales_fact * 0.5 / 100,
                                                        0)
                                              ELSE
                                                   (  NVL (
                                                           sales.sales_fact
                                                         * (tf.norm - 0.5)
                                                         / 100,
                                                         0)
                                                    - NVL (zp.total1, 0)
                                                    - NVL (zay.compens_distr, 0))
                                                 + NVL (sales.sales_fact * 0.5 / 100,
                                                        0)
                                           END
                                        WHEN tf.gsm = 2
                                        THEN
                                             (  NVL (
                                                     sales.sales_fact
                                                   * (tf.norm - 0.5)
                                                   / 100,
                                                   0)
                                              - NVL (zp.total1, 0)
                                              - NVL (zay.compens_distr, 0))
                                           + NVL (sales.sales_fact * 0.5 / 100, 0)
                                        WHEN tf.gsm = 3
                                        THEN
                                             (  NVL (
                                                     sales.sales_fact
                                                   * (tf.norm - 0.5)
                                                   / 100,
                                                   0)
                                              - NVL (zp.total1, 0)
                                              - NVL (zay.compens_distr, 0))
                                           +   NVL (sales.sales_fact * 0.5 / 100, 0)
                                             * 2
                                        ELSE
                                           0
                                     END
                                  ELSE
                                     0
                               END
                             + CASE
                                  WHEN tf.fnd_kod = 'prm'
                                  THEN
                                     - (  NVL (act.compens_distr, 0)
                                        + NVL (act_local.compens_distr, 0)
                                        + NVL (zay.compens_distr, 0))
                                  ELSE
                                     0
                               END
                                total
                        FROM (  SELECT f.id fil_id,
                                       f.name fil_name,
                                       f.sw_kod,
                                       tf.bud_id,
                                       fnd.id fund_id,
                                       fnd.name fund_name,
                                       n.norm,
                                       f.gsm,
                                       c.period,
                                       fnd.kod fnd_kod
                                  FROM bud_fil f,
                                       bud_funds fnd,
                                       bud_tn_fil tf,
                                       user_list u,
                                       bud_funds_norm n,
                                       (SELECT DISTINCT TRUNC (data, 'mm') period
                                          FROM calendar
                                         WHERE data BETWEEN TO_DATE ( :sd,
                                                                     'dd.mm.yyyy')
                                                        AND TO_DATE ( :ed,
                                                                     'dd.mm.yyyy')) c
                                 WHERE     f.id = tf.bud_id
                                       AND f.dpt_id = :dpt_id
                                       AND (   f.data_end IS NULL
                                            OR TRUNC (f.data_end, 'mm') >=
                                                  TO_DATE ( :sd, 'dd.mm.yyyy'))
                                       AND DECODE ( :fil, 0, f.id, :fil) = f.id
                                       AND (   f.id IN (SELECT fil_id
                                                          FROM clusters_fils
                                                         WHERE :clusters = CLUSTER_ID)
                                            OR :clusters = 0)
                                       AND (   :exp_list_without_ts = 0
                                            OR u.tn IN (SELECT slave
                                                          FROM full
                                                         WHERE master =
                                                                  :exp_list_without_ts))
                                       AND u.tn = DECODE ( :db, 0, u.tn, :db)
                                       AND u.is_spd = 1
                                       AND (   u.tn IN (SELECT slave
                                                          FROM full
                                                         WHERE master = :tn)
                                            OR (SELECT NVL (is_traid, 0)
                                                  FROM user_list
                                                 WHERE tn = :tn) = 1
                                            OR (SELECT NVL (is_traid_kk, 0)
                                                  FROM user_list
                                                 WHERE tn = :tn) = 1
                                            OR tf.bud_id IN (SELECT fil_id
                                                               FROM clusters_fils
                                                              WHERE CLUSTER_ID IN (SELECT CLUSTER_ID
                                                                                     FROM clusters_fils
                                                                                    WHERE fil_id IN (SELECT id
                                                                                                       FROM bud_fil
                                                                                                      WHERE login =
                                                                                                               :login)))
                                            OR tf.bud_id = (SELECT id
                                                              FROM bud_fil
                                                             WHERE login = :login))
                                       AND fnd.dpt_id = :dpt_id
                                       AND u.tn = tf.tn
                                       AND c.period = n.dt
                                       AND n.fund = fnd.id
                              GROUP BY f.id,
                                       f.name,
                                       tf.bud_id,
                                       fnd.id,
                                       fnd.name,
                                       f.sw_kod,
                                       n.norm,
                                       f.gsm,
                                       c.period,
                                       fnd.kod) tf,
                             (  SELECT z.cost_assign_month period,
                                       z.fil,
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
                                                                               TRUNC (
                                                                                  z.dt_start,
                                                                                  'mm')
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
                                                                   WHERE     z_id =
                                                                                z.id
                                                                         AND accepted =
                                                                                2)))
                                                  current_accepted_id,
                                               st.name st_name,
                                               kat.name kat_name,
                                                 (  NVL (
                                                       getZayFieldVal (z.id,
                                                                       'var_name',
                                                                       'v3'),
                                                       0)
                                                  + NVL (
                                                       getZayFieldVal (z.id,
                                                                       'var_name',
                                                                       'v4'),
                                                       0))
                                               * 1000
                                                  z_plan,
                                                 (  NVL (
                                                       getZayFieldVal (z.id,
                                                                       'rep_var_name',
                                                                       'rv3'),
                                                       0)
                                                  + NVL (
                                                       getZayFieldVal (z.id,
                                                                       'rep_var_name',
                                                                       'rv4'),
                                                       0))
                                               * 1000
                                                  z_fakt,
                                               NVL (
                                                  TO_NUMBER (
                                                     getZayFieldVal (z.id,
                                                                     'admin_id',
                                                                     8)),
                                                  0)
                                                  by_goods,
                                               NVL (
                                                  TO_NUMBER (
                                                     getZayFieldVal (z.id,
                                                                     'admin_id',
                                                                     9)),
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
                                               AND z.cost_assign_month BETWEEN TO_DATE (
                                                                                  :sd,
                                                                                  'dd.mm.yyyy')
                                                                           AND TO_DATE (
                                                                                  :ed,
                                                                                  'dd.mm.yyyy')
                                               AND z.valid_no = 0
                                               AND (   :exp_list_without_ts = 0
                                                    OR u.tn IN (SELECT slave
                                                                  FROM full
                                                                 WHERE master =
                                                                          :exp_list_without_ts))
                                               AND u.is_spd = 1
                                               AND (   u.tn IN (SELECT slave
                                                                  FROM full
                                                                 WHERE master = :tn)
                                                    OR (SELECT NVL (is_traid, 0)
                                                          FROM user_list
                                                         WHERE tn = :tn) = 1
                                                    OR (SELECT NVL (is_traid_kk, 0)
                                                          FROM user_list
                                                         WHERE tn = :tn) = 1)
                                               AND u.tn = DECODE ( :db, 0, u.tn, :db))
                                       z
                                 WHERE current_accepted_id = 1 AND deleted = 0
                              GROUP BY z.fil, z.funds, z.cost_assign_month) zay,
                             (  SELECT z.cost_assign_month period,
                                       z.fil,
                                       z.funds,
                                       SUM (t.compens_distr) compens_distr,
                                       SUM (t.compens_db) compens_db
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
                                                   (  NVL (
                                                         getZayFieldVal (z.id,
                                                                         'rep_var_name',
                                                                         'rv3'),
                                                         0)
                                                    + NVL (
                                                         getZayFieldVal (z.id,
                                                                         'rep_var_name',
                                                                         'rv4'),
                                                         0))
                                                 * 1000
                                                    bonus_sum,
                                                   (  NVL (
                                                         getZayFieldVal (z.id,
                                                                         'rep_var_name',
                                                                         'rv3'),
                                                         0)
                                                    + NVL (
                                                         getZayFieldVal (z.id,
                                                                         'rep_var_name',
                                                                         'rv4'),
                                                         0))
                                                 * 1000
                                                 * CASE
                                                      WHEN NVL (
                                                              TO_NUMBER (
                                                                 getZayFieldVal (
                                                                    z.id,
                                                                    'admin_id',
                                                                    9)),
                                                              0) = 1
                                                      THEN
                                                         0
                                                      WHEN NVL (
                                                              TO_NUMBER (
                                                                 getZayFieldVal (
                                                                    z.id,
                                                                    'admin_id',
                                                                    8)),
                                                              0) = 0
                                                      THEN
                                                         1
                                                      ELSE
                                                           (  1
                                                            -   NVL (
                                                                   (SELECT discount
                                                                      FROM bud_fil_discount_body
                                                                     WHERE     dt = s.dt
                                                                           AND distr =
                                                                                  z.fil),
                                                                   0)
                                                              / 100)
                                                         * (SELECT bonus_log_koef
                                                              FROM bud_fil
                                                             WHERE id = z.fil)
                                                   END
                                                    compens_distr,
                                                   (  NVL (
                                                         getZayFieldVal (z.id,
                                                                         'rep_var_name',
                                                                         'rv3'),
                                                         0)
                                                    + NVL (
                                                         getZayFieldVal (z.id,
                                                                         'rep_var_name',
                                                                         'rv4'),
                                                         0))
                                                 * 1000
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
                                                    compens_db
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
                                                                             'dd.mm.yyyy'))
                                                 s,
                                                 akcii_local_tp t,
                                                 bud_ru_zay z
                                           WHERE     s.tp_kod = t.tp_kod
                                                 AND t.z_id = z.id
                                                 AND TRUNC (z.dt_start, 'mm') = s.dt
                                        GROUP BY z.id, z.fil, s.dt) t
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
                                                                  WHERE     z_id = z.id
                                                                        AND accepted =
                                                                               2),
                                                                0),
                                                             0, (SELECT MAX (
                                                                           accept_order)
                                                                   FROM bud_ru_zay_accept
                                                                  WHERE z_id = z.id),
                                                             (SELECT MAX (accept_order)
                                                                FROM bud_ru_zay_accept
                                                               WHERE     z_id = z.id
                                                                     AND accepted = 2))) =
                                              1
                                       AND z.valid_no = 0
                                       AND z.cost_assign_month BETWEEN TO_DATE (
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
                                       AND u.is_spd = 1
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
                              GROUP BY z.cost_assign_month, z.fil, z.funds) act_local,
                             (  SELECT z.act_month period,
                                       zp.fil,
                                       z.fund_id,
                                       SUM (s.sales) sales,
                                       SUM (s.bonus) bonus,
                                         SUM (s.bonus)
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
                                           WHERE id = zp.fil)
                                          compens_distr
                                  FROM bud_act_fund z,
                                       act_svod s,
                                       user_list u,
                                       (SELECT dt, fil, h_eta
                                          FROM bud_svod_zp
                                         WHERE     dt BETWEEN TO_DATE ( :sd,
                                                                       'dd.mm.yyyy')
                                                          AND TO_DATE ( :ed,
                                                                       'dd.mm.yyyy')
                                               AND dpt_id = :dpt_id
                                               AND fil IS NOT NULL) zp
                                 WHERE     u.tab_num = s.ts_tab_num
                                       AND u.dpt_id = :dpt_id
                                       AND s.dpt_id = :dpt_id
                                       AND zp.h_eta = s.h_fio_eta
                                       AND z.act_month = zp.dt
                                       AND DECODE ( :fil, 0, zp.fil, :fil) = zp.fil
                                       AND (   zp.fil IN (SELECT fil_id
                                                            FROM clusters_fils
                                                           WHERE :clusters = CLUSTER_ID)
                                            OR :clusters = 0)
                                       AND z.act = s.act
                                       AND TO_NUMBER (TO_CHAR (z.act_month, 'mm')) =
                                              s.m
                                       AND z.act_month BETWEEN TO_DATE ( :sd,
                                                                        'dd.mm.yyyy')
                                                           AND TO_DATE ( :ed,
                                                                        'dd.mm.yyyy')
                                       AND (   :exp_list_without_ts = 0
                                            OR u.tn IN (SELECT slave
                                                          FROM full
                                                         WHERE master =
                                                                  :exp_list_without_ts))
                                       AND u.is_spd = 1
                                       AND (   u.tn IN (SELECT slave
                                                          FROM full
                                                         WHERE master = :tn)
                                            OR (SELECT NVL (is_traid, 0)
                                                  FROM user_list
                                                 WHERE tn = :tn) = 1
                                            OR (SELECT NVL (is_traid_kk, 0)
                                                  FROM user_list
                                                 WHERE tn = :tn) = 1)
                                       AND s.db_tn = DECODE ( :db, 0, s.db_tn, :db)
                              GROUP BY zp.fil, z.fund_id, z.act_month) act,
                             (SELECT dt period,
                                     cust_id,
                                     cust_name,
                                     sales_fact * 1000 sales_fact,
                                     sales_price * 1000 sales_price,
                                     skid_nacenka * 100 skid_nacenka,
                                     sales_2_5 * 1000 sales_2_5,
                                     dop_zarobotok * 1000 dop_zarobotok
                                FROM Sales
                               WHERE dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                            AND TO_DATE ( :ed, 'dd.mm.yyyy')) sales,
                             (  SELECT s.dt period,
                                       zp.fil,
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
                                                              WHERE     dt = s.dt
                                                                    AND distr = zp.fil),
                                                            0)
                                                       / 100)
                                                  * (SELECT bonus_log_koef
                                                       FROM bud_fil
                                                      WHERE id = zp.fil)
                                            END)
                                          compens_distr
                                  FROM (SELECT m.dt,
                                               m.tab_num,
                                               m.tp_kod,
                                               m.y,
                                               m.m,
                                               m.summa,
                                               m.h_eta,
                                               m.eta,
                                               m.bedt_summ,
                                               m.tp_type,
                                               m.tp_ur,
                                               m.tp_addr
                                          FROM a14mega m
                                         WHERE     m.dpt_id = :dpt_id
                                               AND m.dt BETWEEN TO_DATE ( :sd,
                                                                         'dd.mm.yyyy')
                                                            AND TO_DATE ( :ed,
                                                                         'dd.mm.yyyy'))
                                       s,
                                       user_list u,
                                       sc_tp t,
                                       sc_svod sv,
                                       (SELECT dt, fil, h_eta
                                          FROM bud_svod_zp
                                         WHERE     dt BETWEEN TO_DATE ( :sd,
                                                                       'dd.mm.yyyy')
                                                          AND TO_DATE ( :ed,
                                                                       'dd.mm.yyyy')
                                               AND dpt_id = :dpt_id
                                               AND fil IS NOT NULL) zp
                                 WHERE     s.tab_num = u.tab_num
                                       AND u.dpt_id = :dpt_id
                                       AND :dpt_id = t.dpt_id(+)
                                       AND s.tp_kod = t.tp_kod(+)
                                       AND s.tp_kod = sv.tp_kod(+)
                                       AND sv.dt(+) = s.dt
                                       AND s.dt = zp.dt
                                       AND :dpt_id = sv.dpt_id(+)
                                       AND (   discount > 0
                                            OR bonus > 0
                                            OR fixed > 0
                                            OR margin > 0
                                            OR sv.bonus_fakt > 0
                                            OR sv.fixed_fakt > 0)
                                       AND zp.h_eta = s.h_eta
                                       AND (   :exp_list_without_ts = 0
                                            OR u.tn IN (SELECT slave
                                                          FROM full
                                                         WHERE master =
                                                                  :exp_list_without_ts))
                                       AND u.is_spd = 1
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
                             (  SELECT sv.dt period,
                                       f.id fil,
                                       SUM (sv.zp_fakt) sum_zp,
                                       SUM (
                                            NVL (sv.fal_payment, 0)
                                          + NVL (sv.amort, 0)
                                          + NVL (sv.gbo_warmup, 0))
                                          total1
                                  FROM bud_svod_zp sv, bud_fil f
                                 WHERE     sv.fil = f.id
                                       AND sv.dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                                     AND TO_DATE ( :ed, 'dd.mm.yyyy')
                              GROUP BY f.id, sv.dt) zp,
                             (  SELECT dt period,
                                       fil,
                                       SUM (total) fakt_distr,
                                       SUM (compens_distr) compens_distr,
                                       -SUM (skidka_val) skidka_val
                                  FROM (SELECT s.dt,
                                               zp.fil,
                                                 NVL (sv.bonus_fakt, 0)
                                               + NVL (sv.fixed_fakt, 0)
                                                  total,
                                               -s.summskidka skidka_val,
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
                                                                   WHERE     dt = s.dt
                                                                         AND distr =
                                                                                zp.fil),
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
                                                          getZayFieldVal (z.id,
                                                                          'admin_id',
                                                                          4))
                                                          tp_kod
                                                  FROM bud_ru_zay z, user_list u
                                                 WHERE     (SELECT NVL (tu, 0)
                                                              FROM bud_ru_st_ras
                                                             WHERE id = z.kat) = 1
                                                       AND z.tn = u.tn
                                                       AND u.dpt_id = :dpt_id
                                                       AND TRUNC (z.dt_end, 'mm') >=
                                                              TO_DATE ( :sd,
                                                                       'dd.mm.yyyy')
                                                       AND TRUNC (z.dt_start, 'mm') <=
                                                              TO_DATE ( :ed,
                                                                       'dd.mm.yyyy')
                                                       /*AND z.cost_assign_month BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy') AND TO_DATE ( :ed, 'dd.mm.yyyy')*/
                                                       AND z.report_data IS NOT NULL
                                                       AND (SELECT rep_accepted
                                                              FROM bud_ru_zay_accept
                                                             WHERE     z_id = z.id
                                                                   AND INN_not_ReportMA (
                                                                          tn) = 0
                                                                   AND accept_order =
                                                                          DECODE (
                                                                             NVL (
                                                                                (SELECT MAX (
                                                                                           accept_order)
                                                                                   FROM bud_ru_zay_accept
                                                                                  WHERE     z_id =
                                                                                               z.id
                                                                                        AND rep_accepted =
                                                                                               2
                                                                                        AND INN_not_ReportMA (
                                                                                               tn) =
                                                                                               0),
                                                                                0),
                                                                             0, (SELECT MAX (
                                                                                           accept_order)
                                                                                   FROM bud_ru_zay_accept
                                                                                  WHERE     z_id =
                                                                                               z.id
                                                                                        AND rep_accepted
                                                                                               IS NOT NULL
                                                                                        AND INN_not_ReportMA (
                                                                                               tn) =
                                                                                               0),
                                                                             (SELECT MAX (
                                                                                        accept_order)
                                                                                FROM bud_ru_zay_accept
                                                                               WHERE     z_id =
                                                                                            z.id
                                                                                     AND rep_accepted =
                                                                                            2
                                                                                     AND INN_not_ReportMA (
                                                                                            tn) =
                                                                                            0))) =
                                                              1
                                                       AND TO_NUMBER (
                                                              getZayFieldVal (
                                                                 z.id,
                                                                 'admin_id',
                                                                 4))
                                                              IS NOT NULL) t,
                                               sc_svodn sv,
                                               bud_svod_zp zp
                                         WHERE     s.dt = sv.dt(+)
                                               AND s.dpt_id = :dpt_id
                                               AND s.dt = zp.dt(+)
                                               AND zp.dpt_id(+) = :dpt_id
                                               AND s.tab_num = u.tab_num
                                               AND u.dpt_id = :dpt_id
                                               AND s.tp_kod = t.tp_kod
                                               AND s.tp_kod = sv.tp_kod(+)
                                               AND sv.dt(+) = s.dt
                                               AND s.dt BETWEEN TO_DATE ( :sd,
                                                                         'dd.mm.yyyy')
                                                            AND TO_DATE ( :ed,
                                                                         'dd.mm.yyyy')
                                               AND :dpt_id = sv.dpt_id(+)
                                               AND (   :exp_list_without_ts = 0
                                                    OR u.tn IN (SELECT slave
                                                                  FROM full
                                                                 WHERE master =
                                                                          :exp_list_without_ts))
                                               AND u.is_spd = 1
                                               AND (   u.tn IN (SELECT slave
                                                                  FROM full
                                                                 WHERE master = :tn)
                                                    OR (SELECT NVL (is_traid, 0)
                                                          FROM user_list
                                                         WHERE tn = :tn) = 1
                                                    OR (SELECT NVL (is_traid_kk, 0)
                                                          FROM user_list
                                                         WHERE tn = :tn) = 1)
                                               AND zp.h_eta = s.h_eta
                                               AND (zp.fil = :fil OR :fil = 0)
                                               AND (   zp.fil IN (SELECT fil_id
                                                                    FROM clusters_fils
                                                                   WHERE :clusters =
                                                                            CLUSTER_ID)
                                                    OR :clusters = 0)
                                        UNION
                                          SELECT s.dt,
                                                 s.fil,
                                                   NVL (SUM (sv.bonus_fakt), 0)
                                                 + NVL (SUM (sv.fixed_fakt), 0)
                                                    total,
                                                 SUM (skidka_val) skidka_val,
                                                 SUM (
                                                      (  NVL (sv.bonus_fakt, 0)
                                                       + NVL (sv.fixed_fakt, 0))
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
                                                                       WHERE     dt = s.dt
                                                                             AND distr =
                                                                                    s.fil),
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
                                                             WHERE     m.tp_kod =
                                                                          tpn.tp_kod
                                                                   AND u.is_spd = 1
                                                                   AND u.tn = p.tn
                                                                   AND u.tab_num =
                                                                          m.tab_num
                                                                   AND u.dpt_id = m.dpt_id
                                                                   AND f.id = tf.bud_id
                                                                   AND tf.tn = p.parent
                                                                   AND f.dpt_id = m.dpt_id
                                                                   AND (   f.data_end
                                                                              IS NULL
                                                                        OR TRUNC (
                                                                              f.data_end,
                                                                              'mm') >=
                                                                              TO_DATE (
                                                                                 :ed,
                                                                                 'dd.mm.yyyy')))
                                                           s,
                                                           (SELECT DISTINCT
                                                                   TO_NUMBER (
                                                                      getZayFieldVal (
                                                                         z.id,
                                                                         'admin_id',
                                                                         14))
                                                                      chain
                                                              FROM bud_ru_zay z,
                                                                   user_list u
                                                             WHERE     (SELECT NVL (tu, 0)
                                                                          FROM bud_ru_st_ras
                                                                         WHERE id = z.kat) =
                                                                          1
                                                                   AND z.tn = u.tn
                                                                   AND u.dpt_id = :dpt_id
                                                                   AND TRUNC (z.dt_end,
                                                                              'mm') >=
                                                                          TO_DATE (
                                                                             :sd,
                                                                             'dd.mm.yyyy')
                                                                   AND TRUNC (z.dt_start,
                                                                              'mm') <=
                                                                          TO_DATE (
                                                                             :ed,
                                                                             'dd.mm.yyyy')
                                                                   /*AND z.cost_assign_month BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy') AND TO_DATE ( :ed, 'dd.mm.yyyy')*/
                                                                   AND z.report_data
                                                                          IS NOT NULL
                                                                   AND (SELECT rep_accepted
                                                                          FROM bud_ru_zay_accept
                                                                         WHERE     z_id =
                                                                                      z.id
                                                                               AND INN_not_ReportMA (
                                                                                      tn) =
                                                                                      0
                                                                               AND accept_order =
                                                                                      DECODE (
                                                                                         NVL (
                                                                                            (SELECT MAX (
                                                                                                       accept_order)
                                                                                               FROM bud_ru_zay_accept
                                                                                              WHERE     z_id =
                                                                                                           z.id
                                                                                                    AND rep_accepted =
                                                                                                           2
                                                                                                    AND INN_not_ReportMA (
                                                                                                           tn) =
                                                                                                           0),
                                                                                            0),
                                                                                         0, (SELECT MAX (
                                                                                                       accept_order)
                                                                                               FROM bud_ru_zay_accept
                                                                                              WHERE     z_id =
                                                                                                           z.id
                                                                                                    AND rep_accepted
                                                                                                           IS NOT NULL
                                                                                                    AND INN_not_ReportMA (
                                                                                                           tn) =
                                                                                                           0),
                                                                                         (SELECT MAX (
                                                                                                    accept_order)
                                                                                            FROM bud_ru_zay_accept
                                                                                           WHERE     z_id =
                                                                                                        z.id
                                                                                                 AND rep_accepted =
                                                                                                        2
                                                                                                 AND INN_not_ReportMA (
                                                                                                        tn) =
                                                                                                        0))) =
                                                                          1
                                                                   AND TO_NUMBER (
                                                                          getZayFieldVal (
                                                                             z.id,
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
                                                           AND (   s.tn IN (SELECT slave
                                                                              FROM full
                                                                             WHERE master =
                                                                                      :tn)
                                                                OR (SELECT NVL (is_traid,
                                                                                0)
                                                                      FROM user_list
                                                                     WHERE tn = :tn) = 1
                                                                OR (SELECT NVL (
                                                                              is_traid_kk,
                                                                              0)
                                                                      FROM user_list
                                                                     WHERE tn = :tn) = 1)
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
                                                 AND s.dt BETWEEN TO_DATE ( :sd,
                                                                           'dd.mm.yyyy')
                                                              AND TO_DATE ( :ed,
                                                                           'dd.mm.yyyy')
                                                 AND :dpt_id = sv.dpt_id(+)
                                        GROUP BY s.dt, s.fil)
                              GROUP BY dt, fil) svs_new
                       WHERE     tf.fil_id = zay.fil(+)
                             AND tf.period = zay.period(+)
                             AND tf.fil_id = act_local.fil(+)
                             AND tf.fil_id = act.fil(+)
                             AND tf.period = act.period(+)
                             AND tf.fund_id = zay.funds(+)
                             AND tf.fund_id = act_local.funds(+)
                             AND tf.period = act_local.period(+)
                             AND tf.fund_id = act.fund_id(+)
                             AND tf.sw_kod = sales.cust_id(+)
                             AND tf.period = sales.period(+)
                             AND tf.fil_id = svs.fil(+)
                             AND tf.period = svs.period(+)
                             AND tf.fil_id = svs_new.fil(+)
                             AND tf.period = svs_new.period(+)
                             AND tf.fil_id = zp.fil(+)
                             AND tf.period = zp.period(+)
                    ORDER BY tf.fil_name, tf.fund_name, tf.period)
          GROUP BY fil_id,
                   fil_name,
                   fund_id,
                   fund_name,
                   fnd_kod
          ORDER BY fil_name, fund_name)
GROUP BY fil_id, fil_name
ORDER BY fil_name