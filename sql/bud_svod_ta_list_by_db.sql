SELECT   x.tn_db,
         (SELECT fio FROM user_list WHERE tn = x.tn_db) AS db_fio,
         x.fil_id,
         x.fil_name,
         x.fil_kk,
         SUM (x.sales) / COUNT (DISTINCT x.fund_id) sales,
         SUM (x.sales_fact) / COUNT (DISTINCT x.fund_id) sales_fact,
         SUM (CASE WHEN x.fnd_kod = 'svs' THEN x.svs_total ELSE NULL END)
            svs_total,
         SUM (CASE WHEN x.fnd_kod = 'zp' THEN x.zp_total ELSE NULL END) zp_total,
         SUM (CASE WHEN x.fnd_kod = 'gbo' THEN x.gsm_total ELSE NULL END)
            gsm_total,
         SUM (CASE WHEN x.fnd_kod = 'prm' THEN x.promo_total ELSE NULL END)
            promo_total,
         SUM (x.compens_db) compens_db,
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
    FROM (  SELECT tf.tn_db,
                   tf.fil_id,
                   tf.fil_name,
                   tf.fund_id,
                   tf.fund_name,
                   sales.cust_name,
                   sales.sales_fact,
                   tf.norm,
                   tf.fnd_kod,
                   tf.fil_kk,
                   sales.sales_fact * tf.norm / 100 sales_fact_perc_norm,
                   sales.sales_fact * (tf.norm - 0.5) / 100 sales_fact_perc_norm05,
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
                     NVL (act.compens_distr, 0)
                   + NVL (act_local.compens_distr, 0)
                   + NVL (zay.compens_distr, 0)
                      promo_total,
                   NVL (svs.compens_distr, 0) + NVL (svs_new.compens_distr, 0)
                      svs_compens_distr,
                     NVL (svs.compens_distr, 0)
                   + NVL (svs_new.compens_distr, 0)
                   + NVL (zay.compens_distr, 0)
                   + NVL (act_local.compens_distr, 0)
                   + NVL (act.compens_distr, 0)
                      svs_total,
                   NVL (zp.sum_zp, 0) + NVL (zay.compens_distr, 0) zp_total,
                   NVL (zp.total1, 0) + NVL (zay.compens_distr, 0) gsm_total,
                   zp.sales,
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
              FROM (  SELECT tf.tn AS tn_db,
                              (SELECT fio FROM user_list WHERE tn = tf.tn) db_fio,
                             f.id fil_id,
                             f.name fil_name,
                             f.sw_kod,
                             tf.bud_id,
                             fnd.id fund_id,
                             fnd.name fund_name,
                             n.norm,
                             f.gsm,
                             fnd.kod fnd_kod,
                             f.kk fil_kk
                        FROM bud_fil f,
                             bud_funds fnd,
                             bud_tn_fil tf,
                             user_list u,
                             bud_funds_norm n
                       WHERE     f.id = tf.bud_id
                             AND f.dpt_id = :dpt_id
                             AND (   f.data_end IS NULL
                                  OR TRUNC (f.data_end, 'mm') >=
                                        TO_DATE ( :dt, 'dd.mm.yyyy'))
                             AND DECODE ( :fil, 0, f.id, :fil) = f.id
                             AND (   f.id IN (SELECT fil_id
                                                FROM clusters_fils
                                               WHERE :clusters = CLUSTER_ID)
                                  OR :clusters = 0)
                             AND (   :exp_list_without_ts = 0
                                  OR u.tn IN (SELECT slave
                                                FROM full
                                               WHERE master = :exp_list_without_ts))
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
                                       WHERE tn = :tn) = 1)
                             AND fnd.dpt_id = :dpt_id
                             AND u.tn = tf.tn
                             AND TO_DATE ( :dt, 'dd.mm.yyyy') = n.dt(+)
                             AND n.fund(+) = fnd.id
                    GROUP BY tf.tn,
                             f.id,
                             f.name,
                             tf.bud_id,
                             fnd.id,
                             fnd.name,
                             f.sw_kod,
                             n.norm,
                             f.gsm,
                             fnd.kod,
                             f.kk ) tf, /* перечень фондов с кодами (по ДБ)*/ /* все ДБ по филиалу */
                   (  SELECT z.db_tn tn_db,
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
                                                              AND distr = z.fil),
                                                      0)
                                                 / 100)
                                            * (SELECT bonus_log_koef
                                                 FROM bud_fil
                                                WHERE id = z.fil)
                                      END
                                END)
                                compens_distr,
                             SUM (CASE WHEN via_db = 1 THEN z_fakt ELSE NULL END)
                                compens_db
                        FROM (SELECT (SELECT tn FROM user_list WHERE is_db = 1 AND tn = z.tn) AS db_tn,
                                     z.*,
                                     DECODE ( (SELECT COUNT (*)
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
                                                               AND accepted = 2)))
                                        current_accepted_id,
                                     st.name st_name,
                                     kat.name kat_name,
                                       (  NVL (
                                             getZayFieldVal (z.id, 'var_name', 'v3'),
                                             0)
                                        + NVL (
                                             getZayFieldVal (z.id, 'var_name', 'v4'),
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
                                           getZayFieldVal (z.id, 'admin_id', 8)),
                                        0)
                                        by_goods,
                                     NVL (
                                        TO_NUMBER (
                                           getZayFieldVal (z.id, 'admin_id', 9)),
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
                                     AND z.cost_assign_month =
                                            TO_DATE ( :dt, 'dd.mm.yyyy')
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
                                     AND u.tn = DECODE ( :db, 0, u.tn, :db)
                                     ) z
                            
                       WHERE current_accepted_id = 1 AND deleted = 0 
                    GROUP BY z.db_tn, z.fil, z.funds ) zay, /* расходы по заявкам (план,факт..) (по ДБ)*/   /* только учавствующие ДБ */
                   (  SELECT z.tn tn_db,
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
                                                       getZayFieldVal (z.id,
                                                                       'admin_id',
                                                                       9)),
                                                    0) = 1
                                            THEN
                                               0
                                            WHEN NVL (
                                                    TO_NUMBER (
                                                       getZayFieldVal (z.id,
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
                                                       getZayFieldVal (z.id,
                                                                       'admin_id',
                                                                       9)),
                                                    0) = 1
                                            THEN
                                               1
                                         END
                                          compens_db,
                                       TRUNC (z.dt_start, 'mm') period
                                  FROM (SELECT m.tab_num,
                                               m.tp_kod,
                                               m.y,
                                               m.m,
                                               m.summa,
                                               m.h_eta,
                                               m.eta,
                                               m.dt
                                          FROM a14mega m
                                         WHERE m.dpt_id = :dpt_id) s,
                                       akcii_local_tp t,
                                       bud_ru_zay z
                                 WHERE     s.tp_kod = t.tp_kod
                                       AND t.z_id = z.id
                                       AND s.dt = TRUNC (z.dt_start, 'mm')
                              GROUP BY z.id, z.fil, z.dt_start) t
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
                             AND z.cost_assign_month = TO_DATE ( :dt, 'dd.mm.yyyy')
                             AND (   :exp_list_without_ts = 0
                                  OR u.tn IN (SELECT slave
                                                FROM full
                                               WHERE master = :exp_list_without_ts))
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
                    GROUP BY z.tn, z.fil, z.funds ) act_local, /* затраты по локальным акциям (по ДБ)*/ /* только учавствующие ДБ */
                   (  SELECT z.db_tn tn_db,
                          z.fil,
                         z.fund_id,
                         SUM (z.sales) sales,
                         SUM (z.bonus) bonus,
                         SUM (z.compens_distr) compens_distr
                    FROM (  SELECT s.db_tn,
                                   zp.fil,
                                   z.fund_id,
                                   SUM (s.sales) sales,
                                   SUM (s.bonus) bonus,
                                     SUM (s.bonus)
                                   * (  1
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
                                      compens_distr
                              FROM bud_act_fund z,
                                   act_svod s,
                                   user_list u,
                                   (SELECT fil, h_eta
                                      FROM bud_svod_zp
                                     WHERE     dt = TO_DATE ( :dt, 'dd.mm.yyyy')
                                           AND dpt_id = :dpt_id
                                           AND fil IS NOT NULL) zp
                             WHERE     u.tab_num = s.ts_tab_num
                                   AND u.dpt_id = :dpt_id
                                   AND s.dpt_id = :dpt_id
                                   AND zp.h_eta = s.h_fio_eta
                                   AND DECODE ( :fil, 0, zp.fil, :fil) = zp.fil
                                   AND (   zp.fil IN (SELECT fil_id
                                                        FROM clusters_fils
                                                       WHERE :clusters = CLUSTER_ID)
                                        OR :clusters = 0)
                                   AND z.act = s.act
                                   AND TO_NUMBER (TO_CHAR (z.act_month, 'mm')) = s.m
                                   AND z.act_month = TO_DATE ( :dt, 'dd.mm.yyyy')
                                   AND (   :exp_list_without_ts = 0
                                        OR u.tn IN (SELECT slave
                                                      FROM full
                                                     WHERE master = :exp_list_without_ts))
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
                          GROUP BY s.db_tn, zp.fil, z.fund_id
                          UNION
                            SELECT s.db_tn,
                                   s.fil_kod,
                                   z.fund_id,
                                   SUM (s.sales) sales,
                                   SUM (s.bonus) bonus,
                                     SUM (s.bonus)
                                   * (  1
                                      -   NVL (
                                             (SELECT discount
                                                FROM bud_fil_discount_body
                                               WHERE     dt = TO_DATE ( :dt, 'dd.mm.yyyy')
                                                     AND distr = s.fil_kod),
                                             0)
                                        / 100)
                                   * (SELECT bonus_log_koef
                                        FROM bud_fil
                                       WHERE id = s.fil_kod)
                                      compens_distr
                              FROM bud_act_fund z, act_svodn s, user_list u
                             WHERE     u.tab_num = s.ts_tab_num
                                   AND u.dpt_id = :dpt_id
                                   AND DECODE ( :fil, 0, s.fil_kod, :fil) = s.fil_kod
                                   AND (   s.fil_kod IN (SELECT fil_id
                                                           FROM clusters_fils
                                                          WHERE :clusters = CLUSTER_ID)
                                        OR :clusters = 0)
                                   AND z.act = s.act
                                   AND TO_NUMBER (TO_CHAR (z.act_month, 'mm')) = s.m
                                   AND z.act_month = TO_DATE ( :dt, 'dd.mm.yyyy')
                                   AND (   :exp_list_without_ts = 0
                                        OR u.tn IN (SELECT slave
                                                      FROM full
                                                     WHERE master = :exp_list_without_ts))
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
                          GROUP BY s.db_tn, s.fil_kod, z.fund_id) z
                    GROUP BY z.db_tn,z.fil, z.fund_id ) act, /* затраты по национальным акциям (по ДБ)*/  /* только учавствующие ДБ | empty */
                   (  SELECT cust_id,
                           cust_name,
                           sales_fact * 1000 sales_fact,
                           sales_price * 1000 sales_price,
                           skid_nacenka * 100 skid_nacenka,
                           sales_2_5 * 1000 sales_2_5,
                           dop_zarobotok * 1000 dop_zarobotok
                      FROM Sales
                     WHERE dt = TO_DATE ( :dt, 'dd.mm.yyyy') ) sales, /* продажи по дистрибьюторам */
                   (  SELECT 
                            sv.OK_DB_TN tn_db,
                             zp.fil,
                             SUM (
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
                                                                 TO_DATE (
                                                                    :dt,
                                                                    'dd.mm.yyyy')
                                                          AND distr = zp.fil),
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
                                     m.bedt_summ,
                                     m.tp_type,
                                     m.tp_ur,
                                     m.tp_addr
                                FROM a14mega m
                               WHERE     m.dpt_id = :dpt_id
                                     AND m.dt = TO_DATE ( :dt, 'dd.mm.yyyy')) s,
                             user_list u,
                             sc_tp t,
                             sc_svod sv,
                             (SELECT fil, h_eta
                                FROM bud_svod_zp
                               WHERE     dt = TO_DATE ( :dt, 'dd.mm.yyyy')
                                     AND dpt_id = :dpt_id
                                     AND fil IS NOT NULL) zp
                       WHERE     s.tab_num = u.tab_num
                             AND u.dpt_id = :dpt_id
                             AND :dpt_id = t.dpt_id(+)
                             AND s.tp_kod = t.tp_kod(+)
                             AND s.tp_kod = sv.tp_kod(+)
                             AND sv.dt(+) = TO_DATE ( :dt, 'dd.mm.yyyy')
                             AND :dpt_id = sv.dpt_id(+)
                             AND (   discount > 0
                                  OR bonus > 0
                                  OR fixed > 0
                                  OR margin > 0
                                  OR sv.bonus_fakt > 0
                                  OR sv.fixed_fakt > 0)
                             AND sv.OK_DB_TN IS NOT NULL /* fix 02.04.2019 */
                             AND zp.h_eta = s.h_eta
                             AND (   :exp_list_without_ts = 0
                                  OR u.tn IN (SELECT slave
                                                FROM full
                                               WHERE master = :exp_list_without_ts))
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
                    GROUP BY sv.OK_DB_TN, zp.fil ) svs, /* затраты по старым ТУ по дистрибьюторам (по ДБ)*/  /* только учавствующие ДБ */
                   (  SELECT (SELECT u.tn FROM user_list u WHERE u.is_db = 1 AND u.tn = z.tn_db) tn_db,
                             z.fil,
                             SUM (z.zp_fakt) sum_zp,
                             SUM (
                                  NVL (z.fal_payment, 0)
                                + NVL (z.amort, 0)
                                + NVL (z.gbo_warmup, 0))
                                total1,
                             SUM (z.sales) sales
                        FROM (SELECT u.chief_tn as tn_db,
                                     sv.id,
                                     sv.fil,
                                     sv.zp_fakt,
                                     sv.fal_payment,
                                     sv.amort,
                                     sv.gbo_warmup,
                                     sv.sales
                                FROM (  SELECT m.tab_num,
                                               m.h_eta,
                                               m.eta,
                                               m.eta_tab_number,
                                               SUM (m.summa) summa,
                                               SUM (m.coffee) coffee
                                          FROM a14mega m
                                         WHERE     m.dpt_id = :dpt_id
                                               AND TO_DATE ( :dt, 'dd.mm.yyyy') = m.dt
                                      GROUP BY m.tab_num,
                                               m.h_eta,
                                               m.eta,
                                               m.eta_tab_number) s,
                                     user_list u,
                                     bud_svod_zp sv,
                                     (SELECT h_eta,
                                               (  NVL (val_plan, 0)
                                                + NVL (coffee_plan, 0))
                                             * 1000
                                                val_plan,
                                               (  NVL (val_fact, 0)
                                                + NVL (coffee_fact, 0))
                                             * 1000
                                                val_fact
                                        FROM kpr k
                                       WHERE     k.dpt_id = :dpt_id
                                             AND TO_DATE ( :dt, 'dd.mm.yyyy') = k.dt)
                                     vp/*,
                                     ( SELECT DISTINCT u.tn, tf.BUD_ID AS fil_id
                                        FROM user_list u,
                                             BUD_TN_FIL tf,
                                             bud_fil f
                                        WHERE 
                                            u.tn = tf.TN
                                            AND tf.BUD_ID = f.ID(+)
                                            AND u.IS_DB = 1
                                            AND u.DATAUVOL IS NULL
                                            AND (f.data_end IS NULL or f.data_end >= trunc(SYSDATE)) 
                                        GROUP BY u.tn , tf.BUD_ID) db_tn*/
                               WHERE     ( :fil = sv.fil OR :fil = 0)
                                     AND (   sv.fil IN (SELECT fil_id
                                                          FROM clusters_fils
                                                         WHERE :clusters = CLUSTER_ID)
                                          OR :clusters = 0)
                                     AND s.tab_num = u.tab_num
                                     AND u.dpt_id = :dpt_id
                                     AND TO_DATE ( :dt, 'dd.mm.yyyy') = sv.dt
                                     AND :dpt_id = sv.dpt_id
                                     AND s.h_eta = sv.h_eta
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
                                     AND sv.unscheduled = 0
                                     AND s.h_eta = vp.h_eta(+)
                                     --AND sv.fil = db_tn.fil_id(+)
                                     
                              UNION
                              SELECT u.chief_tn AS tn_db,
                                     sv.id,
                                     sv.fil,
                                     sv.zp_fakt,
                                     sv.fal_payment,
                                     sv.amort,
                                     sv.gbo_warmup,
                                     sv.sales
                                FROM user_list u, bud_svod_zp sv
                               /* ,( SELECT DISTINCT u.tn, tf.BUD_ID AS fil_id
                                        FROM user_list u,
                                             BUD_TN_FIL tf,
                                             bud_fil f
                                        WHERE 
                                            u.tn = tf.TN
                                            AND tf.BUD_ID = f.ID(+)
                                            AND u.IS_DB = 1
                                            AND u.DATAUVOL IS NULL
                                            AND (f.data_end IS NULL or f.data_end >= trunc(SYSDATE)) 
                                        GROUP BY u.tn , tf.BUD_ID) db_tn*/
                               WHERE     ( :fil = sv.fil OR :fil = 0)
                                     AND (   sv.fil IN (SELECT fil_id
                                                          FROM clusters_fils
                                                         WHERE :clusters = CLUSTER_ID)
                                          OR :clusters = 0)
                                     AND sv.tn = u.tn
                                     AND u.dpt_id = sv.dpt_id
                                     AND TO_DATE ( :dt, 'dd.mm.yyyy') = sv.dt
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
                                     AND sv.unscheduled = 1
                                    -- AND sv.fil = db_tn.fil_id(+) 
                    ) z
                    GROUP BY  z.tn_db , z.fil ) zp, /* затраты на ЗП сотрудников относящихся к филиалу  (по ДБ)*/  /* только учавствующие ДБ */
                   (  SELECT ok_db_tn tn_db, 
                           fil,
                           prot_db,
                           ok_db_tn,
                           ok_t1_tn,
                           ok_pr_tn,
                           ok_t2_tn,
                           TO_CHAR (ok_db_lu, 'dd.mm.yyyy hh24:mi:ss') ok_db_lu,
                           TO_CHAR (ok_t1_lu, 'dd.mm.yyyy hh24:mi:ss') ok_t1_lu,
                           TO_CHAR (ok_pr_lu, 'dd.mm.yyyy hh24:mi:ss') ok_pr_lu,
                           TO_CHAR (ok_t2_lu, 'dd.mm.yyyy hh24:mi:ss') ok_t2_lu,
                           ok_db_fio,
                           ok_t1_fio,
                           ok_pr_fio,
                           ok_t2_fio
                      FROM bud_svod_taf
                     WHERE dt = TO_DATE ( :dt, 'dd.mm.yyyy') ) taf, /* сканкопии подтверждающие затраты по Филиал\ДБ (по ДБ)*/ /*  ТУТ СМОТРЕТЬ  */ /* только ОДИН ДБ */
                   (  SELECT tn_db, fil, SUM (compens_distr) compens_distr
                        FROM (SELECT sv.OK_DB_TN AS tn_db,
                                     s.dt,
                                     zp.fil,
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
                                             AND TO_DATE ( :dt, 'dd.mm.yyyy') /*= z.cost_assign_month*/
                                                                             BETWEEN TRUNC (
                                                                                        z.dt_start,
                                                                                        'mm')
                                                                                 AND TRUNC (
                                                                                        z.dt_end,
                                                                                        'mm')
                                             AND z.report_data IS NOT NULL
                                             AND (SELECT rep_accepted
                                                    FROM bud_ru_zay_accept
                                                   WHERE     z_id = z.id
                                                         AND INN_not_ReportMA (tn) =
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
                                                    getZayFieldVal (z.id,
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
                                     AND sv.OK_DB_TN IS NOT NULL /* fix 02.04.2019 */
                                     AND s.dt = TO_DATE ( :dt, 'dd.mm.yyyy')
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
                                                         WHERE :clusters = CLUSTER_ID)
                                          OR :clusters = 0)
                                     AND sv.OK_DB_TN IS NOT NULL 
                              UNION
                                SELECT sv.OK_DB_TN AS tn_db,
                                       s.dt,
                                       s.fil,
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
                                                                   AND distr = s.fil),
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
                                                         AND u.is_spd = 1
                                                         AND u.tn = p.tn
                                                         AND u.tab_num = m.tab_num
                                                         AND u.dpt_id = m.dpt_id
                                                         AND f.id = tf.bud_id
                                                         AND tf.tn = p.parent
                                                         AND f.dpt_id = m.dpt_id
                                                         AND (   f.data_end IS NULL
                                                              OR TRUNC (f.data_end, 'mm') >=
                                                                    TO_DATE (
                                                                       :dt,
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
                                                         AND TO_DATE ( :dt, 'dd.mm.yyyy') /*= z.cost_assign_month*/
                                                                                         BETWEEN TRUNC (
                                                                                                    z.dt_start,
                                                                                                    'mm')
                                                                                             AND TRUNC (
                                                                                                    z.dt_end,
                                                                                                    'mm')
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
                                       AND s.dt = TO_DATE ( :dt, 'dd.mm.yyyy')
                                       AND :dpt_id = sv.dpt_id(+)
                                       AND sv.OK_DB_TN IS NOT NULL 
                              GROUP BY sv.OK_DB_TN, s.dt, s.fil)
                    GROUP BY tn_db ,fil ) svs_new /* затраты по новым ТУ (по ДБ)*/
             WHERE     tf.fil_id = zay.fil(+)
      AND tf.tn_db = zay.tn_db(+)
                   AND tf.fil_id = act_local.fil(+)
      AND tf.tn_db = act_local.tn_db(+)
                   AND tf.fil_id = act.fil(+)
      AND tf.tn_db = act.tn_db(+)
                   AND tf.fund_id = zay.funds(+)
                   AND tf.fund_id = act_local.funds(+)
                   AND tf.fund_id = act.fund_id(+)
                   AND tf.sw_kod = sales.cust_id(+)
                   AND tf.fil_id = svs.fil(+)
      AND tf.tn_db = svs.tn_db(+)
                   AND tf.fil_id = svs_new.fil(+)
      AND tf.tn_db = svs_new.tn_db(+)
                   AND tf.fil_id = zp.fil(+)
      AND tf.tn_db = zp.tn_db(+)
                   AND tf.fil_id = taf.fil(+)
      AND tf.tn_db = taf.tn_db(+)
          ORDER BY tf.fil_name, tf.fund_name) x
   WHERE     DECODE ( :ok_db, 1, 0, DECODE (x.ok_db_tn, NULL, 0, 1)) =
                DECODE ( :ok_db,  1, 0,  2, 1,  3, 0)
         AND DECODE ( :ok_t1, 1, 0, DECODE (x.ok_t1_tn, NULL, 0, 1)) =
                DECODE ( :ok_t1,  1, 0,  2, 1,  3, 0)
         AND DECODE ( :ok_pr, 1, 0, DECODE (x.ok_pr_tn, NULL, 0, 1)) =
                DECODE ( :ok_pr,  1, 0,  2, 1,  3, 0)
         AND DECODE ( :ok_t2, 1, 0, DECODE (x.ok_t2_tn, NULL, 0, 1)) =
                DECODE ( :ok_t2,  1, 0,  2, 1,  3, 0)
         AND x.sales IS NOT NULL OR x.SVS_TOTAL <> 0 OR x.ZP_TOTAL <> 0 OR x.PROMO_TOTAL <> 0
GROUP BY x.tn_db,
         x.fil_id,
         x.fil_name,
         x.fil_kk,
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
ORDER BY x.fil_name
