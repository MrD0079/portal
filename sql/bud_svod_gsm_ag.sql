/* Formatted on 09/04/2015 17:43:51 (QP5 v5.227.12220.39724) */
SELECT NVL (sv.id, FN_GET_NEW_ID) id,
       u.fio ts,
       r.h_eta,
       r.eta,
       sv.fal_payment,
       NVL (sv.unscheduled, 0) unscheduled,
       r.eta_tab_number,
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
       f.name fil_name,
       DECODE (
          NVL (sv.sales, 0),
          0, 0,
            (  NVL (sv.fal_payment, 0)
             + NVL (sv.amort, 0)
             + NVL (sv.gbo_warmup, 0))
          / sv.sales
          * 100)
          perc_zat,
       taf.ok_db_tn,
       sv.gbo_warmup
  FROM (SELECT DISTINCT m.tab_num,
                        m.h_eta,
                        m.eta,
                        m.eta_tab_number
          FROM a14mega m
         WHERE m.dpt_id = :dpt_id AND TO_DATE (:dt, 'dd.mm.yyyy') = m.dt) r,
       user_list u,
       bud_svod_zp sv,
       bud_fil f,
       (SELECT fil, ok_db_tn
          FROM bud_svod_taf
         WHERE dt = TO_DATE (:dt, 'dd.mm.yyyy')) taf
 WHERE     sv.fil = f.id(+)
       AND sv.fil = taf.fil(+)
       AND DECODE (:fil, 0, f.id, :fil) = f.id
       AND (   f.id IN (SELECT fil_id
                          FROM clusters_fils
                         WHERE :clusters = CLUSTER_ID)
            OR :clusters = 0)
       AND r.tab_num = u.tab_num
       /*AND u.datauvol IS NULL*/
       AND u.dpt_id = :dpt_id
and u.is_spd=1
       AND TO_DATE (:dt, 'dd.mm.yyyy') = sv.dt(+)
       AND :dpt_id = sv.dpt_id(+)
       AND r.h_eta = sv.h_eta(+)
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
       AND (:eta_list is null OR :eta_list = r.h_eta)
       AND sv.unscheduled = 0
UNION
SELECT sv.id,
       u.fio ts,
       sv.h_eta,
       sv.fio eta,
       sv.fal_payment,
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
       f.name fil_name,
       DECODE (
          NVL (sv.sales, 0),
          0, 0,
            (  NVL (sv.fal_payment, 0)
             + NVL (sv.amort, 0)
             + NVL (sv.gbo_warmup, 0))
          / sv.sales
          * 100)
          perc_zat,
       taf.ok_db_tn,
       sv.gbo_warmup
  FROM user_list u,
       bud_svod_zp sv,
       bud_fil f,
       (SELECT fil, ok_db_tn
          FROM bud_svod_taf
         WHERE dt = TO_DATE (:dt, 'dd.mm.yyyy')) taf
 WHERE     sv.fil = f.id(+)
       AND sv.fil = taf.fil(+)
       AND DECODE (:fil, 0, f.id, :fil) = f.id
       AND (   f.id IN (SELECT fil_id
                          FROM clusters_fils
                         WHERE :clusters = CLUSTER_ID)
            OR :clusters = 0)
       AND sv.tn = u.tn
       /*AND u.datauvol IS NULL*/
       AND u.dpt_id = sv.dpt_id
 and u.is_spd=1
      AND TO_DATE (:dt, 'dd.mm.yyyy') = sv.dt(+)
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
       AND sv.unscheduled = 1
ORDER BY unscheduled NULLS FIRST, ts, eta