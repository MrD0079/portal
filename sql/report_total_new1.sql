/* Formatted on 14.11.2016 14:58:12 (QP5 v5.252.13127.32867) */
  SELECT q1.dt,
         q1.dt1,
         q1.head_id,
         q1.login,
         q1.num,
         q1.kodtp,
         q1.mr_fakt,
         /*q1.f_fakt,*/
         g.in_out,
         NVL (g.minutes, 0) minutes,
         g.kod_ag,
         q1.plan,
         q1.plan - NVL (g.minutes, 0) gps_delta,
         CASE
            WHEN    DECODE (NVL (g.minutes, 0),
                            0, 0,
                            plan / NVL (g.minutes, 0)) > 1.1
                 OR plan - NVL (g.minutes, 0) > 10
            THEN
               1
         END
            is_red,
         vv,
         q1.cpp1_id
    FROM (  SELECT DISTINCT
                   DECODE (
                      NVL (
                         SUM (
                            CASE
                               WHEN rb.vv = 1 AND NVL (mr_fakt, 0) /*+ NVL (f_fakt, 0)*/
                                                                  >= 10 THEN 1
                            END),
                         0),
                      0, 0,
                      1)
                      vv,
                   TO_CHAR (mr.dt, 'dd.mm.yyyy') dt,
                   mr.dt dt1,
                   rh.id head_id,
                   rh.login,
                   rh.num,
                   cpp1.kodtp,
                   SUM (mr_fakt) mr_fakt,
                   /*SUM (f_fakt) f_fakt,*/
                   ROUND ( (NVL (SUM (rb.DAY_TIME_MR), 0) /*+ NVL (SUM (rb.DAY_TIME_F), 0)*/
                                                         )) plan,
                   ROUND ( (NVL (SUM (rb.DAY_TIME_MR), 0) /*+ NVL (SUM (rb.DAY_TIME_F), 0)*/
                                                         ) /*- NVL (g.minutes, 0)*/
                                                          ) gps_delta,
                   CASE
                      WHEN    DECODE (                  /*NVL (g.minutes, 0)*/
                                      0, 0, 0, (NVL (SUM (rb.DAY_TIME_MR), 0) /*+ NVL (SUM (rb.DAY_TIME_F), 0)*/
                                                                             ) /*/ NVL (g.minutes, 0)*/
                                                                              ) >
                                 1.1
                           OR (NVL (SUM (rb.DAY_TIME_MR), 0) /*+ NVL (SUM (rb.DAY_TIME_F), 0)*/
                                                            ) /*- NVL (g.minutes, 0)*/
                                                             > 10
                      THEN
                         1
                   END
                      is_red,
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
                   (SELECT DISTINCT data, dm FROM calendar) c
             WHERE     mr.dt BETWEEN TO_DATE ( :sd, 'dd/mm/yyyy')
                                 AND TO_DATE ( :ed, 'dd/mm/yyyy')
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
                   AND cpp1.kodtp = rt.kodtp
                   AND n.id_net = cpp1.id_net
                   AND DECODE ( :svms_list, 0, 0, rh.tn) =
                          DECODE ( :svms_list, 0, 0, :svms_list)
                   AND rha.ag_id IN ( :ha)
                   AND DECODE ( :select_route_numb, 0, 0, rh.id) =
                          DECODE ( :select_route_numb, 0, 0, :select_route_numb)
                   AND (   rh.tn IN (SELECT slave
                                       FROM full
                                      WHERE master = :tn)
                        OR (SELECT is_admin
                              FROM user_list
                             WHERE tn = :tn) = 1
                        OR (SELECT is_ma
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
                   AND (rb.DAY_enabled_MR = 1      /*OR rb.DAY_enabled_F = 1*/
                                             )
          GROUP BY mr.dt,
                   rh.id,
                   rh.login,
                   rh.num,
                   cpp1.kodtp,
                   cpp1.id) q1,
         (  SELECT dt,
                   kod_ag,
                   kod_tp,
                   SUM (time_out - time_in) * 24 * 60 minutes,
                   wm_concat (
                         TO_CHAR (time_in, 'hh24:mi')
                      || '-'
                      || TO_CHAR (time_out, 'hh24:mi'))
                      in_out
              FROM merch_report_gps
          GROUP BY dt, kod_tp, kod_ag) g
   WHERE q1.dt1 = g.dt(+) AND q1.cpp1_id = g.kod_tp(+) AND q1.num = g.kod_ag(+)
ORDER BY q1.dt1, q1.num, q1.kodtp