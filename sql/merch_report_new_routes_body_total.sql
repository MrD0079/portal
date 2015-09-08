/* Formatted on 06/08/2015 15:26:21 (QP5 v5.227.12220.39724) */
  SELECT SUM (day_enabled_mr) day_enabled_mr,
         SUM (day_time_mr) day_time_mr,
         /*SUM (day_enabled_f) day_enabled_f,*/
         /*SUM (day_time_f) day_time_f,*/
         SUM (NVL (mr_fakt, 0)) mr_fakt,
         /*SUM (NVL (f_fakt, 0)) f_fakt,*/
         /*SUM (ras) ras,*/
         SUM (mr_delta) mr_delta,
         /*SUM (f_delta) f_delta,*/
         SUM (NVL (minutes, 0)) minutes,
         DECODE (
            SUM (DECODE (mr_fakt, NULL, DECODE (day_time_mr, NULL, 0, 1), 0))/*+ SUM (DECODE (f_fakt, NULL, DECODE (day_time_f, NULL, 0, 1), 0))*/
                                                                             ,
            0, 1,
            0)
            zapolnen,
         ROUND ( (NVL (SUM (day_time_mr), 0) /*+ NVL (SUM (day_time_f), 0)*/
                                            )) plan,
         ROUND ( (NVL (SUM (day_time_mr), 0) /*+ NVL (SUM (day_time_f), 0)*/
                                            ) - SUM (NVL (minutes, 0)))
            gps_delta,
         SUM (
            CASE
               WHEN    DECODE (NVL (minutes, 0),
                               0, 0,
                               (NVL (day_time_mr, 0) /*+ NVL (day_time_f, 0)*/
                                                    ) / NVL (minutes, 0)) > 1.1
                    OR (NVL (day_time_mr, 0) /*+ NVL (day_time_f, 0)*/
                                            ) - NVL (minutes, 0) > 10
                    OR NVL (day_time_mr, 0) /*+ NVL (day_time_f, 0)*/
                                           <= 10
               THEN
                  1
            END)
            is_red,
         svms_ok,
         svms_ok_date
    FROM (  SELECT cpp.kodtp,
                   SUM (rb.day_enabled_mr) day_enabled_mr,
                   /*SUM (rb.day_enabled_f) day_enabled_f,*/
                   SUM (rb.day_time_mr) day_time_mr,
                   /*SUM (rb.day_time_f) day_time_f,*/
                   SUM (- (rb.day_time_mr - mr_fakt)) mr_delta,
                   /*SUM (- (rb.day_time_f - f_fakt)) f_delta,*/
                   SUM (mr_fakt) mr_fakt,
                   /*SUM (f_fakt) f_fakt,*/
                   /*SUM (ras) ras,*/
                   g.in_out,
                   NVL (g.minutes, 0) minutes,
                   g.kod_ag,
                   (SELECT svms_ok
                      FROM merch_report_ok
                     WHERE     dt = TO_DATE (:dates_list, 'dd/mm/yyyy')
                           AND head_id = :route)
                      svms_ok,
                   (SELECT TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss')
                      FROM merch_report_ok
                     WHERE     dt = TO_DATE (:dates_list, 'dd/mm/yyyy')
                           AND head_id = :route)
                      svms_ok_date
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
                             WHERE head_id = :route) ha,
                           routes_agents a
                     WHERE cpp1.tz_oblast = s.oblast AND a.id = ha.ag_id) cpp,
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
                   AND (rb.day_enabled_mr = 1     /* OR rb.day_enabled_f = 1*/
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
          GROUP BY cpp.kodtp,
                   g.in_out,
                   NVL (g.minutes, 0),
                   g.kod_ag)
GROUP BY svms_ok, svms_ok_date