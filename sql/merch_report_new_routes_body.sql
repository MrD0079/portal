/* Formatted on 06/08/2015 17:47:20 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT
         (SELECT wm_concat (name)
            FROM MERCH_REPORT_CAL_REMINDERS
           WHERE     ag_id = cpp.ag_id
                 AND head_id = :route
                 AND kodtp = cpp.kodtp
                 AND data = TO_DATE (:dates_list, 'dd/mm/yyyy'))
            reminders,
         cpp.tz_oblast,
         (SELECT net_name
            FROM ms_nets
           WHERE id_net = cpp.id_net)
            net_name,
         ur_tz_name,
         tz_address,
         cpp.kodtp,
         cpp.ag_name,
         cpp.ag_id,
         rb.id,
         rb.day_enabled_mr,
         rb.day_time_mr,
         /*rb.day_enabled_f,*/
         /*rb.day_time_f,*/
         - (rb.day_time_mr - MR_FAKT) MR_DELTA,
         /*- (rb.day_time_f - f_FAKT) f_DELTA,*/
         (SELECT COUNT (*)
            FROM merch_spec_head msh, merch_spec_body msb
           WHERE     msh.kod_tp = cpp.kodtp
                 AND msb.head_id = msh.id
                 AND msh.ag_id = cpp.ag_id
                 AND msh.id_net = cpp.id_net)
            spec,
         (SELECT id
            FROM merch_spec_head msh
           WHERE     msh.kod_tp = cpp.kodtp
                 AND msh.ag_id = cpp.ag_id
                 AND msh.id_net = cpp.id_net
                 AND msh.sd =
                        (SELECT MAX (sd)
                           FROM merch_spec_head
                          WHERE     id_net = cpp.id_net
                                AND kod_tp = cpp.kodtp
                                AND ag_id = cpp.ag_id
                                AND sd <= TO_DATE (:dates_list, 'dd/mm/yyyy')))
            spec_id,
         RB_ID,
         mr.DT,
         MR_FAKT MR_FAKT,
         /*F_FAKT F_FAKT,
         RAS,*/
         MR_TEXT,
         /*F_TEXT,
         RAS_TEXT,*/
         rb.vv,
         g.in_out,
         NVL (g.minutes, 0) minutes,
         g.kod_ag,
         ROUND ( (NVL (rb.day_time_mr, 0) /*+ NVL (rb.day_enabled_f, 0)*/
                                         )) plan,
         ROUND ( (NVL (rb.day_time_mr, 0) /*+ NVL (rb.day_enabled_f, 0)*/
                                         ) - NVL (g.minutes, 0)) gps_delta,
         DECODE (
            SIGN (
                 15
               - ABS (ROUND ( (NVL (rb.day_time_mr, 0) /*+ NVL (rb.day_enabled_f, 0)*/
                                                      ) - NVL (g.minutes, 0)))),
            -1, 1,
            0)
            is_red
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
         AND (rb.day_enabled_mr = 1               /* OR rb.day_enabled_f = 1*/
                                   )
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
ORDER BY tz_oblast,
         net_name,
         ur_tz_name,
         tz_address,
         kodtp,
         ag_name