/* Formatted on 18/05/2015 19:27:03 (QP5 v5.227.12220.39724) */
SELECT NVL (sv.id, FN_GET_NEW_ID) id,
       u.fio ts,
       u.tab_num ts_tn,
       s.h_eta h_eta,
       s.eta eta,
       sv.dz_return,
       sv.dz_return * n.norm / 100 dz_return_norm,
       sv.dz_return * 0.003 dz_return_norm03,
       DECODE (NVL (sv.sales, 0),
               0, 0,
               sv.dz_return * n.norm / 100 / sv.sales * 100)
          sales_perc,
       sv.akb_penalty,
       sv.fal_payment,
       sv.dz_return * n.norm / 100 - NVL (sv.akb_penalty, 0) zp_plan,
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
       NVL (sv.fal_payment, 0) + NVL (sv.amort, 0) + NVL (sv.gbo_warmup, 0)
          total1,
       sv.fil,
       sv.sales,
       s.summa,
       f.name fil_name,
       f.id fil_id,
       taf.ok_db_tn
  FROM (  SELECT m.tab_num,
                 m.h_eta,
                 m.eta,
                 m.eta_tab_number,
                 SUM (m.summa) summa
            FROM a14mega m
           WHERE m.dpt_id = :dpt_id AND TO_DATE (:dt, 'dd.mm.yyyy') = m.dt
        GROUP BY m.tab_num,
                 m.h_eta,
                 m.eta,
                 m.eta_tab_number) s,
       user_list u,
       bud_svod_zp sv,
       bud_fil f,
       (SELECT fil, ok_db_tn
          FROM bud_svod_taf
         WHERE dt = TO_DATE (:dt, 'dd.mm.yyyy')) taf,
       (SELECT n1.norm,
               n1.dt,
               n1.fund,
               f1.kod
          FROM bud_funds_norm n1, bud_funds f1
         WHERE n1.fund = f1.id AND f1.dpt_id = :dpt_id) n
 WHERE     sv.fil = f.id(+)
       AND sv.fil = taf.fil(+)
       /*AND DECODE (:fil, 0, sv.fil, :fil) = sv.fil*/
       AND (:fil = sv.fil OR :fil = 0)
       AND (   sv.fil IN (SELECT fil_id
                            FROM clusters_fils
                           WHERE :clusters = CLUSTER_ID)
            OR :clusters = 0)
       AND s.tab_num = u.tab_num
       /*AND u.datauvol IS NULL*/
       AND u.dpt_id = :dpt_id
       AND TO_DATE (:dt, 'dd.mm.yyyy') = sv.dt(+)
       AND :dpt_id = sv.dpt_id(+)
       AND s.h_eta = sv.h_eta(+)
       AND u.tn IN
              (SELECT slave
                 FROM full
                WHERE master =
                         DECODE (:exp_list_without_ts,
                                 0, master,
                                 :exp_list_without_ts))
       AND u.tn IN
              (SELECT slave
                 FROM full
                WHERE master =
                         DECODE (:exp_list_only_ts,
                                 0, master,
                                 :exp_list_only_ts))
       AND (   u.tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn)
            OR (SELECT NVL (is_traid, 0)
                  FROM user_list
                 WHERE tn = :tn) = 1
            OR (SELECT NVL (is_traid_kk, 0)
                  FROM user_list
                 WHERE tn = :tn) = 1)
       AND DECODE (:eta_list, '', s.h_eta, :eta_list) = s.h_eta
       AND sv.unscheduled(+) = 0
       AND sv.dt = n.dt(+)
       AND n.kod(+) = 'zp'
UNION
SELECT sv.id,
       u.fio ts,
       u.tab_num ts_tn,
       sv.h_eta,
       sv.fio eta,
       sv.dz_return,
       sv.dz_return * n.norm / 100 dz_return_norm,
       sv.dz_return * n.norm / 100 * 0.3 dz_return_norm03,
       DECODE (NVL (sv.sales, 0),
               0, 0,
               sv.dz_return * n.norm / 100 / sv.sales * 100)
          sales_perc,
       sv.akb_penalty,
       sv.fal_payment,
       sv.dz_return / 100 - NVL (sv.akb_penalty, 0) gsm_plan,
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
       NVL (sv.fal_payment, 0) + NVL (sv.amort, 0) + NVL (sv.gbo_warmup, 0)
          total1,
       sv.fil,
       sv.sales,
       NULL summa,
       f.name fil_name,
       f.id fil_id,
       taf.ok_db_tn
  FROM user_list u,
       bud_svod_zp sv,
       bud_fil f,
       (SELECT fil, ok_db_tn
          FROM bud_svod_taf
         WHERE dt = TO_DATE (:dt, 'dd.mm.yyyy')) taf,
       (SELECT n1.norm,
               n1.dt,
               n1.fund,
               f1.kod
          FROM bud_funds_norm n1, bud_funds f1
         WHERE n1.fund = f1.id AND f1.dpt_id = :dpt_id) n
 WHERE     sv.fil = f.id(+)
       AND sv.fil = taf.fil(+)
       /*AND DECODE (:fil, 0, sv.fil, :fil) = sv.fil*/
       AND (:fil = sv.fil OR :fil = 0)
       AND (   sv.fil IN (SELECT fil_id
                            FROM clusters_fils
                           WHERE :clusters = CLUSTER_ID)
            OR :clusters = 0)
       AND sv.tn = u.tn
       /*AND u.datauvol IS NULL*/
       AND u.dpt_id = sv.dpt_id
       AND TO_DATE (:dt, 'dd.mm.yyyy') = sv.dt(+)
       AND u.tn IN
              (SELECT slave
                 FROM full
                WHERE master =
                         DECODE (:exp_list_without_ts,
                                 0, master,
                                 :exp_list_without_ts))
       AND u.tn IN
              (SELECT slave
                 FROM full
                WHERE master =
                         DECODE (:exp_list_only_ts,
                                 0, master,
                                 :exp_list_only_ts))
       AND (   u.tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn)
            OR (SELECT NVL (is_traid, 0)
                  FROM user_list
                 WHERE tn = :tn) = 1
            OR (SELECT NVL (is_traid_kk, 0)
                  FROM user_list
                 WHERE tn = :tn) = 1)
       AND DECODE (:eta_list, '', sv.h_eta, :eta_list) = sv.h_eta
       AND sv.unscheduled(+) = 1
       AND sv.dt = n.dt(+)
       AND n.kod(+) = 'zp'
ORDER BY unscheduled NULLS FIRST,                                     /*ts, */
                                 eta