/* Formatted on 06.12.2016 15:14:28 (QP5 v5.252.13127.32867) */
SELECT COUNT (*) c,
       SUM (dz_return) dz_return,
       SUM (dz_return_norm) dz_return_norm,
       SUM (fal_payment) fal_payment,
       SUM (zp_plan) zp_plan,
       SUM (zp_fakt) zp_fakt,
       SUM (probeg) probeg,
       SUM (gbo) gbo,
       SUM (amort) amort,
       SUM (total1) total1,
       DECODE (SUM (fal_payment),
               0, 0,
               SUM (amort) / SUM (fal_payment) * 100)
          amort_perc,
       SUM (DECODE (fil_id, NULL, 1, 0)) fil_null,
       SUM (DECODE (fil_id, NULL, 0, 1)) fil_not_null,
       SUM (summa) summa,
       SUM (sales) sales,
       SUM (val_fact) val_fact,
       DECODE (SUM (sales), 0, 0, SUM (dz_return) / SUM (sales) * 100)
          plan_perc
  FROM (SELECT NVL (sv.id, FN_GET_NEW_ID) id,
               u.fio ts,
               u.tab_num ts_tn,
               s.h_eta h_eta,
               s.eta eta,
               NVL (vp.val_fact, 0) val_fact,
               vp.val_plan dz_return,
                 CASE
                    WHEN s.eta_coffee = 1
                    THEN
                       0.03
                    WHEN DECODE (NVL (vp.val_plan, 0),
                                 0, 0,
                                 (NVL (vp.val_fact, 0)) / vp.val_plan * 100) <
                            80
                    THEN
                       0.01
                    ELSE
                       0.02
                 END
               * sv.sales
                  dz_return_norm,
                 CASE
                    WHEN s.eta_coffee = 1
                    THEN
                       0.03
                    WHEN DECODE (NVL (vp.val_plan, 0),
                                 0, 0,
                                 (NVL (vp.val_fact, 0)) / vp.val_plan * 100) <
                            80
                    THEN
                       0.01
                    ELSE
                       0.02
                 END
               * 100
                  sales_perc,
               DECODE (NVL (vp.val_plan, 0),
                       0, 0,
                       (NVL (vp.val_fact, 0)) / vp.val_plan * 100)
                  plan_perc,
               sv.fal_payment,
                 CASE
                    WHEN s.eta_coffee = 1
                    THEN
                       0.03
                    WHEN DECODE (NVL (vp.val_plan, 0),
                                 0, 0,
                                 (NVL (vp.val_fact, 0)) / vp.val_plan * 100) <
                            80
                    THEN
                       0.01
                    ELSE
                       0.02
                 END
               * sv.sales
                  zp_plan,
               ROUND (
                    CASE
                       WHEN s.eta_coffee = 1
                       THEN
                          0.03
                       WHEN DECODE (
                               NVL (vp.val_plan, 0),
                               0, 0,
                               (NVL (vp.val_fact, 0)) / vp.val_plan * 100) <
                               80
                       THEN
                          0.01
                       ELSE
                          0.02
                    END
                  * sv.sales)
                  zp_fakt_def,
               sv.zp_fakt,
               NVL (sv.unscheduled, 0) unscheduled,
               s.eta_tab_number,
               sv.probeg,
               sv.gbo,
               sv.amort,
               DECODE (NVL (sv.fal_payment, 0),
                       0, 0,
                       sv.amort / sv.fal_payment * 100)
                  amort_perc,
                 NVL (sv.fal_payment, 0)
               + NVL (sv.amort, 0)
               + NVL (sv.gbo_warmup, 0)
                  total1,
               sv.fil,
               sv.sales,
               NVL (s.summa, 0) + NVL (s.coffee, 0) summa,
               f.name fil_name,
               f.id fil_id,
               taf.ok_db_tn,
               s.eta_coffee
          FROM (  SELECT m.tab_num,
                         m.h_eta,
                         m.eta,
                         m.eta_tab_number,
                         SUM (m.summa) summa,
                         SUM (m.coffee) coffee,
                         eta_coffee
                    FROM a14mega m
                   WHERE     m.dpt_id = :dpt_id
                         AND TO_DATE ( :dt, 'dd.mm.yyyy') = m.dt
                GROUP BY m.tab_num,
                         m.h_eta,
                         m.eta,
                         m.eta_tab_number,
                         eta_coffee) s,
               user_list u,
               bud_svod_zp sv,
               bud_fil f,
               (SELECT fil, ok_db_tn
                  FROM bud_svod_taf
                 WHERE dt = TO_DATE ( :dt, 'dd.mm.yyyy')) taf,
               (SELECT n1.norm,
                       n1.dt,
                       n1.fund,
                       f1.kod
                  FROM bud_funds_norm n1, bud_funds f1
                 WHERE n1.fund = f1.id AND f1.dpt_id = :dpt_id) n,
               (SELECT h_eta,
                       (NVL (val_plan, 0) + NVL (coffee_plan, 0)) * 1000
                          val_plan,
                       (NVL (val_fact, 0) + NVL (coffee_fact, 0)) * 1000
                          val_fact
                  FROM kpr k
                 WHERE     k.dpt_id = :dpt_id
                       AND TO_DATE ( :dt, 'dd.mm.yyyy') = k.dt) vp
         WHERE     sv.fil = f.id(+)
               AND sv.fil = taf.fil(+)
               AND ( :fil = sv.fil OR :fil = 0)
               AND (   sv.fil IN (SELECT fil_id
                                    FROM clusters_fils
                                   WHERE :clusters = CLUSTER_ID)
                    OR :clusters = 0)
               AND s.tab_num = u.tab_num
               AND u.dpt_id = :dpt_id
and u.is_spd=1
               AND TO_DATE ( :dt, 'dd.mm.yyyy') = sv.dt(+)
               AND :dpt_id = sv.dpt_id(+)
               AND s.h_eta = sv.h_eta(+)
               AND s.h_eta = vp.h_eta(+)
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
               AND ( :eta_list IS NULL OR :eta_list = s.h_eta)
               AND sv.unscheduled(+) = 0
               AND sv.dt = n.dt(+)
               AND n.kod(+) = 'zp'
        UNION
        SELECT sv.id,
               u.fio ts,
               u.tab_num ts_tn,
               sv.h_eta,
               sv.fio eta,
               NULL val_fact,
               NULL dz_return,
               NULL dz_return_norm,
               NULL sales_perc,
               NULL plan_perc,
               sv.fal_payment,
               NULL zp_plan,
               NULL zp_fakt_def,
               sv.zp_fakt,
               NVL (sv.unscheduled, 0) unscheduled,
               sv.eta_tab_number,
               sv.probeg,
               sv.gbo,
               sv.amort,
               DECODE (NVL (sv.fal_payment, 0),
                       0, 0,
                       sv.amort / sv.fal_payment * 100)
                  amort_perc,
                 NVL (sv.fal_payment, 0)
               + NVL (sv.amort, 0)
               + NVL (sv.gbo_warmup, 0)
                  total1,
               sv.fil,
               sv.sales,
               NULL summa,
               f.name fil_name,
               f.id fil_id,
               taf.ok_db_tn,
               NULL eta_coffee
          FROM user_list u,
               bud_svod_zp sv,
               bud_fil f,
               (SELECT fil, ok_db_tn
                  FROM bud_svod_taf
                 WHERE dt = TO_DATE ( :dt, 'dd.mm.yyyy')) taf,
               (SELECT n1.norm,
                       n1.dt,
                       n1.fund,
                       f1.kod
                  FROM bud_funds_norm n1, bud_funds f1
                 WHERE n1.fund = f1.id AND f1.dpt_id = :dpt_id) n
         WHERE     sv.fil = f.id(+)
               AND sv.fil = taf.fil(+)
               AND ( :fil = sv.fil OR :fil = 0)
               AND (   sv.fil IN (SELECT fil_id
                                    FROM clusters_fils
                                   WHERE :clusters = CLUSTER_ID)
                    OR :clusters = 0)
               AND sv.tn = u.tn
               AND u.dpt_id = sv.dpt_id
          and u.is_spd=1
     AND TO_DATE ( :dt, 'dd.mm.yyyy') = sv.dt(+)
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
               AND sv.unscheduled(+) = 1
               AND sv.dt = n.dt(+)
               AND n.kod(+) = 'zp'
        ORDER BY unscheduled NULLS FIRST, eta)