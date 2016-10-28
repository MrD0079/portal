/* Formatted on 24/06/2016 15:12:43 (QP5 v5.252.13127.32867) */
SELECT COUNT (*) c,
       SUM (plan_minutes) plan_minutes,
       SUM (plan_mr) plan_mr,
       SUM (fakt_minutes) fakt_minutes,
       SUM (fakt_mr) fakt_mr
  FROM (/* Formatted on 24/06/2016 18:10:15 (QP5 v5.252.13127.32867) */
  SELECT plan.*, fakt.fakt_minutes, NVL (fakt.fakt_mr, 0) fakt_mr
    FROM (SELECT TO_CHAR (c.data, 'dd.mm.yyyy') dt,
                 c.data,
                 u.fio,
                 rh.num,
                 rh.fio_otv,
                 cpp1.tz_oblast,
                 n.net_name,
                 ur_tz_name,
                 tz_address,
                 ra.name ag_name,
                 rb.vv,
                 rb.id rb_id,
                 rb.day_TIME_MR plan_minutes,
                 CASE WHEN rb.day_TIME_MR > 0 THEN 1 ELSE 0 END plan_mr
            FROM routes_body1 rb,
                 routes_head rh,
                 routes_head_agents rha,
                 routes_agents ra,
                 routes_tp rt,
                 cpp cpp1,
                 svms_oblast s,
                 ms_nets n,
                 (SELECT DISTINCT data, dm FROM calendar) c,
                 user_list u
           WHERE     c.data BETWEEN TO_DATE ( :sd, 'dd/mm/yyyy')
                                AND TO_DATE ( :ed, 'dd/mm/yyyy')
                 AND rh.data = TRUNC (c.data, 'mm')
                 AND u.tn = rh.tn
                 AND rb.day_num = c.dm
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
                 AND (rb.DAY_enabled_MR = 1)) plan,
         (SELECT mr.dt,
                 mr.rb_id,
                 MR_FAKT fakt_minutes,
                 CASE WHEN MR_FAKT > 0 THEN 1 END fakt_mr
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
                 merch_report_ok mro
           WHERE     mr.dt BETWEEN TO_DATE ( :sd, 'dd/mm/yyyy')
                               AND TO_DATE ( :ed, 'dd/mm/yyyy')
                 AND rh.data = TRUNC (c.data, 'mm')
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
                 AND (  NVL (
                           (SELECT id
                              FROM merch_report_vv
                             WHERE     head_id = rh.id
                                   AND ag_id = ra.id
                                   AND kod_tp = cpp1.kodtp
                                   AND dt = mr.dt),
                           0)
                      + rb.vv <> 1)
                 AND (rb.DAY_enabled_MR = 1)
                 AND mro.dt = mr.dt
                 AND mro.head_id = rh.id) fakt
   WHERE plan.data = fakt.dt(+) AND plan.rb_id = fakt.rb_id(+)
ORDER BY data,
         num,
         fio_otv,
         tz_oblast,
         net_name,
         ur_tz_name,
         tz_address,
         ag_name)