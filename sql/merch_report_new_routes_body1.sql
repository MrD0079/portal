/* Formatted on 27.01.2014 20:20:28 (QP5 v5.227.12220.39724) */
  SELECT tz_oblast,
         net_name,
         ur_tz_name,
         tz_address,
         kodtp,
         SUM (NVL (minutes, 0)) minutes,
         ROUND ( (NVL (SUM (day_time_mr), 0) /*+ NVL (SUM (day_time_f), 0)*/)) plan,
         ROUND (
              (NVL (SUM (day_time_mr), 0) /*+ NVL (SUM (day_time_f), 0)*/)
            - SUM (NVL (minutes, 0)))
            gps_delta,
         CASE
            WHEN    DECODE (
                       SUM (NVL (minutes, 0)),
                       0, 0,
                         (  NVL (SUM (day_time_mr), 0)
                          /*+ NVL (SUM (day_time_f), 0)*/)
                       / SUM (NVL (minutes, 0))) > 1.1
                 OR   (NVL (SUM (day_time_mr), 0) /*+ NVL (SUM (day_time_f), 0)*/)
                    - SUM (NVL (minutes, 0)) > 10
            THEN
               1
         END
            is_red
    FROM (  SELECT cpp.tz_oblast,
                   (SELECT net_name
                      FROM ms_nets
                     WHERE id_net = cpp.id_net)
                      net_name,
                   ur_tz_name,
                   tz_address,
                   cpp.kodtp,
                   SUM (mr_fakt) mr_fakt,
                   /*SUM (f_fakt) f_fakt,*/
                   /*SUM (ras) ras,*/
                   SUM (rb.day_time_mr) day_time_mr,
                   /*SUM (rb.day_time_f) day_time_f,*/
                   g.in_out,
                   NVL (g.minutes, 0) minutes,
                   g.kod_ag
              FROM (SELECT cpp1.*,
                           a.id ag_id,
                           a.name ag_name,
                           ha.vv,
                           (SELECT num
                              FROM routes_head
                             WHERE id = :route)
                              num
                      FROM cpp cpp1,
                           (SELECT *
                              FROM svms_oblast
                             WHERE tn = (SELECT tn
                                           FROM routes_head
                                          WHERE id = :route)) s,
                           (SELECT *
                              FROM routes_head_agents
                             WHERE HEAD_ID = :route) ha,
                           routes_agents a
                     WHERE cpp1.tz_oblast = s.oblast AND A.ID = HA.AG_ID) cpp,
                   (SELECT rb1.*, NULL ag_name
                      FROM routes_body1 rb1
                     WHERE rb1.head_id = :route AND rb1.day_num = :day) rb,
                   routes_tp rt,
                   (SELECT *
                      FROM merch_report
                     WHERE dt = TO_DATE (:dates_list, 'dd/mm/yyyy')) mr,
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
             WHERE     TO_DATE (:dates_list, 'dd/mm/yyyy') = g.dt(+)
                   AND cpp.id = g.kod_tp(+)
                   AND cpp.num = g.kod_ag(+)
                   AND cpp.kodtp = rb.kodtp(+)
                   AND cpp.ag_id = rb.ag_id(+)
                   AND cpp.kodtp = rt.kodtp
                   AND cpp.vv = rb.vv(+)
                   AND cpp.vv = rt.vv
                   AND (rb.day_enabled_mr = 1 /*OR rb.day_enabled_f = 1*/)
                   AND rt.head_id = :route
                   AND rb.id = mr.rb_id(+)
                   AND (  NVL (
                             (SELECT id
                                FROM merch_report_vv
                               WHERE     head_id = rt.head_id
                                     AND ag_id = cpp.ag_id
                                     AND kod_tp = cpp.kodtp
                                     AND dt = TO_DATE (:dates_list, 'dd/mm/yyyy')),
                             0)
                        + rb.vv <> 1)
          GROUP BY cpp.tz_oblast,
                   cpp.id_net,
                   ur_tz_name,
                   tz_address,
                   cpp.kodtp,
                   g.in_out,
                   NVL (g.minutes, 0),
                   g.kod_ag)
GROUP BY tz_oblast,
         net_name,
         ur_tz_name,
         tz_address,
         kodtp
ORDER BY tz_oblast,
         net_name,
         ur_tz_name,
         tz_address,
         kodtp