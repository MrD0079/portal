/* Formatted on 01/07/2015 17:26:57 (QP5 v5.227.12220.39724) */
  SELECT q1.tn,
         q1.id,
         q1.fio,
         q1.fio_otv,
         q1.num,
         DECODE (NVL (t.work_hours, 0),
                 0, 0,
                 SUM (g.minutes) / 60 / t.work_hours)
            fakt_gps,
         q1.rh_num,
         t.justification,
         t.work_hours,
         t.plan_work_days,
         DECODE (NVL (t.work_hours, 0), 0, 0, td.hours / t.work_hours) fakt,
         DECODE (NVL (t.work_hours, 0),
                 0, 0,
                 (SUM (g.minutes) / 60 - td.hours) / t.work_hours)
            delta,
         t.ktt,
         t.ktp,
         NVL (t.ktt, 0) - NVL (t.ktp, 0) ktdelta,
         t.kto,
         t.bonus,
         t.penalty,
         t.obosn
    FROM (  SELECT DISTINCT
                   TO_CHAR (mr.dt, 'dd.mm.yyyy') dt,
                   mr.dt dt1,
                   rh.tn,
                   rh.id,
                   u.fio,
                   rh.fio_otv,
                   SUM (mr_fakt) mr_fakt,
                   /*SUM (f_fakt) f_fakt,*/
                   ROUND (
                      (  NVL (SUM (rb.day_time_mr), 0)
                       /*+ NVL (SUM (rb.day_time_f), 0)*/))
                      gps_delta,
                   NVL (SUM (rb.day_time_mr), 0) day_TIME_MR,
                   /*NVL (SUM (rb.day_time_f), 0) day_TIME_F,*/
                   rh.num,
                   cpp1.id cpp1_id,
                   rh.num rh_num,
                   COUNT (rb.kodtp) kodtp_cnt
              FROM merch_report mr,
                   routes_body1 rb,
                   routes_head rh,
                   routes_head_agents rha,
                   routes_agents ra,
                   routes_tp rt,
                   cpp cpp1,
                   svms_oblast s,
                   ms_nets n,
                   (SELECT DISTINCT data, dm FROM calendar) c,
                   user_list u
             WHERE     u.tn = rh.tn
                   AND TRUNC (mr.dt, 'mm') = TO_DATE (:ed, 'dd/mm/yyyy')
                   AND mr.dt = c.data
                   AND rb.day_num = c.dm
                   AND rb.id = mr.rb_id
                   AND rh.id = rb.head_id
                   AND rh.id = rha.head_id
                   AND ra.id = rha.ag_id
                   AND ra.id = rb.ag_id
                   AND rh.id = rt.head_id
                   AND rb.kodtp = rt.kodtp
                   AND rh.tn = s.tn
                   AND rb.vv = rha.vv
                   AND rha.vv = rt.vv
                   AND cpp1.tz_oblast = s.oblast
                   AND cpp1.kodtp = rb.kodtp
                   AND cpp1.gps = 1
                   AND rh.gps = 1
                   AND cpp1.kodtp = rt.kodtp
                   AND n.id_net = cpp1.id_net
                   AND DECODE (:svms_list, 0, 0, rh.tn) =
                          DECODE (:svms_list, 0, 0, :svms_list)
                   AND DECODE (:fio_otv, '0', '0', rh.fio_otv) =
                          DECODE (:fio_otv, '0', '0', :fio_otv)
                   AND DECODE (:numb, '0', '0', rh.id) =
                          DECODE (:numb, '0', '0', :numb)
                   AND (   rh.tn IN (SELECT emp_tn
                                       FROM who_full
                                      WHERE exp_tn = :tn)
                        OR (SELECT is_ma
                              FROM user_list
                             WHERE tn = :tn) = 1
                        OR (SELECT is_admin
                              FROM user_list
                             WHERE tn = :tn) = 1)
                   AND (  NVL (
                             (SELECT id
                                FROM merch_report_vv
                               WHERE     head_id = rh.id
                                     AND ag_id = ra.id
                                     AND kod_tp = cpp1.kodtp
                                     AND dt = mr.dt),
                             0)
                        + rb.vv <> 1)
                   AND (rb.day_enabled_mr = 1 /*OR rb.day_enabled_f = 1*/)
                   AND (SELECT svms_ok
                          FROM merch_report_ok
                         WHERE dt = mr.dt AND head_id = rh.id) = 1
          GROUP BY mr.dt,
                   rh.tn,
                   rh.fio_otv,
                   u.fio,
                   rh.id,
                   rh.num,
                   cpp1.id,
                   cpp1.city,
                   cpp1.tz_oblast,
                   rh.num) q1,
         (  SELECT c1.data dt,
                   kod_ag,
                   c1.id kod_tp,
                   SUM (time_out - time_in) * 24 * 60 minutes
              FROM merch_report_gps,
                   (SELECT *
                      FROM calendar, cpp
                     WHERE TRUNC (data, 'mm') = TO_DATE (:ed, 'dd/mm/yyyy')) c1
             WHERE c1.data = dt(+) AND c1.id = kod_tp(+)
          GROUP BY c1.data,
                   c1.id,
                   kod_ag,
                   kod_tp) g,
         ms_tabel t,
         (  SELECT head_id,
                   SUM (CASE WHEN hours BETWEEN 0 AND 24 THEN hours ELSE 0 END)
                      hours
              FROM ms_tabel_days
          GROUP BY head_id) td
   WHERE     q1.num = g.kod_ag(+)
         AND q1.dt1 = g.dt(+)
         AND q1.cpp1_id = g.kod_tp(+)
         AND q1.id = t.head_id(+)
         AND q1.id = td.head_id(+)
GROUP BY q1.tn,
         q1.id,
         q1.fio,
         q1.fio_otv,
         q1.num,
         q1.rh_num,
         t.justification,
         t.work_hours,
         t.plan_work_days,
         td.hours,
         t.ktt,
         t.ktp,
         t.kto,
         t.bonus,
         t.penalty,
         t.obosn
ORDER BY q1.fio, q1.rh_num, q1.fio_otv