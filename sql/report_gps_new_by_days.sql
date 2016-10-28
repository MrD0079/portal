/* Formatted on 06/08/2015 15:29:59 (QP5 v5.227.12220.39724) */
  SELECT id,
         dt,
         dt1,
         tn,
         fio,
         fio_otv,
         num,
         NVL (SUM (day_time_mr), 0) /*+ NVL (SUM (day_time_f), 0)*/ plan,
         NVL (SUM (mr_fakt), 0) /*+ NVL (SUM (f_fakt), 0)*/ fakt,
           NVL (SUM (day_time_mr), 0)
         /*+ NVL (SUM (day_time_f), 0)*/
         - (NVL (SUM (mr_fakt), 0) /*+ NVL (SUM (f_fakt), 0)*/)
            delta,
         ROUND (SUM (minutes)) minutes,
         ROUND (SUM (gps_delta)) gps_delta,
         TO_CHAR (MIN (min_time_in), 'hh24:mi') min_time_in,
         TO_CHAR (MAX (max_time_out), 'hh24:mi') max_time_out,
         DECODE (
            MAX (max_time_out) - MIN (min_time_in),
            NULL, NULL,
               TRUNC (24 * (MAX (max_time_out) - MIN (min_time_in)))
            || ':'
            || ROUND (
                  60 * MOD (24 * (MAX (max_time_out) - MIN (min_time_in)), 1)))
            work_day_time,
         60 * 24 * (MAX (max_time_out) - MIN (min_time_in)) z1,
         DECODE (
            SIGN (510 - (60 * 24 * (MAX (max_time_out) - MIN (min_time_in)))),
            1, 1,
            0)
            work_day_is_red,
         SUM (plan_tp_ok) tp_cnt,
         COUNT (DISTINCT gps_kod_tp) gps_tp_cnt,
         SUM (plan_tp_ok) - COUNT (DISTINCT gps_kod_tp) gps_delta_tp
    FROM (  SELECT DISTINCT
                   q1.dt,
                   q1.dt1,
                   q1.tn,
                   q1.id,
                   q1.fio,
                   q1.fio_otv,
                   q1.num,
                   SUM (q1.mr_fakt) mr_fakt,
                   /*SUM (q1.f_fakt) f_fakt,*/
                   wm_concat (g.in_out) in_out,
                   g.minutes,
                   g.kod_ag,
                   SUM (q1.gps_delta) - NVL (g.minutes, 0) gps_delta,
                   SUM (q1.day_TIME_MR) day_TIME_MR,
                   /*SUM (q1.day_TIME_f) day_TIME_f,*/
                   q1.cpp1_id kod_tp,
                   q1.plan_tp_ok,
                   q1.fakt_tp_ok,
                   DECODE (q1.fakt_tp_ok, 0, NULL, g.gps_kod_tp) gps_kod_tp,
                   MIN (g.min_time_in) min_time_in,
                   MAX (g.max_time_out) max_time_out
              FROM (  SELECT DISTINCT
                             CASE
                                WHEN     SUM (rb.vv) = 0
                                     AND   NVL (SUM (rb.day_time_mr), 0)
                                         /*+ NVL (SUM (rb.day_time_f), 0)*/ > 10
                                THEN
                                   1
                             END
                                plan_tp_ok,
                             DECODE (
                                SUM (
                                   CASE
                                      WHEN     rb.vv = 0
                                           AND NVL (mr_fakt, 0) /*+ NVL (f_fakt, 0)*/ >
                                                  0
                                      THEN
                                         1
                                      WHEN     rb.vv = 1
                                           AND NVL (mr_fakt, 0) /*+ NVL (f_fakt, 0)*/ >
                                                  10
                                      THEN
                                         1
                                   END),
                                0, 0,
                                1)
                                fakt_tp_ok,
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
                             cpp1.id cpp1_id
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
                             AND mr.dt BETWEEN TO_DATE (:sd, 'dd/mm/yyyy')
                                           AND TO_DATE (:ed, 'dd/mm/yyyy')
                             AND mr.dt = c.data
                             AND c.dm = rb.day_num
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
                             AND DECODE (:otv_list, '0', '0', rh.fio_otv) =
                                    DECODE (:otv_list, '0', '0', :otv_list)
                             AND DECODE (:num_list, '0', '0', rh.num) =
                                    DECODE (:num_list, '0', '0', :num_list)
                             AND (   rh.tn IN (SELECT slave
                               FROM full
                              WHERE master = :tn)
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
                    GROUP BY mr.dt,
                             rh.tn,
                             rh.fio_otv,
                             u.fio,
                             rh.id,
                             rh.num,
                             cpp1.id) q1,
                   (  SELECT c1.data dt,
                             kod_ag,
                             c1.id kod_tp,
                             kod_tp gps_kod_tp,
                             MIN (time_in) min_time_in,
                             MAX (time_out) max_time_out,
                             SUM (time_out - time_in) * 24 * 60 minutes,
                             wm_concat (
                                   TO_CHAR (time_in, 'hh24:mi')
                                || '-'
                                || TO_CHAR (time_out, 'hh24:mi'))
                                in_out
                        FROM merch_report_gps,
                             (SELECT *
                                FROM calendar, cpp
                               WHERE data BETWEEN TO_DATE (:sd, 'dd/mm/yyyy')
                                              AND TO_DATE (:ed, 'dd/mm/yyyy')) c1
                       WHERE c1.data = dt(+) AND c1.id = kod_tp(+)
                    GROUP BY c1.data,
                             c1.id,
                             kod_ag,
                             kod_tp) g
             WHERE     q1.num = g.kod_ag(+)
                   AND q1.dt1 = g.dt(+)
                   AND q1.cpp1_id = g.kod_tp(+)
          GROUP BY q1.dt,
                   q1.dt1,
                   g.minutes,
                   g.kod_ag,
                   q1.num,
                   q1.tn,
                   q1.fio_otv,
                   q1.fio,
                   q1.cpp1_id,
                   g.gps_kod_tp,
                   q1.plan_tp_ok,
                   q1.fakt_tp_ok,
                   q1.id
          ORDER BY q1.fio, q1.fio_otv, q1.dt1)
GROUP BY id,
         dt,
         dt1,
         tn,
         fio,
         fio_otv,
         num
ORDER BY fio, fio_otv, dt1