/* Formatted on 12.04.2017 11:36:09 (QP5 v5.252.13127.32867) */
  SELECT cpp.tz_oblast,
         (SELECT net_name
            FROM ms_nets
           WHERE id_net = cpp.id_net)
            net_name,
         ur_tz_name,
         tz_address,
         cpp.kodtp,
         cpp.ag_name,
         cpp.ag_id,
         cpp.dm,
         cpp.dw,
         cpp.dwt,
         cpp.is_wd,
         rb.day_num,
         rb.DAY_ENABLED_MR,
         rb.DAY_TIME_MR,
         o.svms_ok
    FROM (SELECT cpp1.*,
                 a.id ag_id,
                 a.name ag_name,
                 c.dm,
                 c.dw,
                 c.dwt,
                 c.is_wd,
                 c.data
            FROM cpp cpp1,
                 routes_agents a,
                 calendar c,
                 routes_head h,
                 routes_head_agents ha,
                 svms_oblast s
           WHERE     cpp1.tz_oblast = s.oblast
                 AND A.ID = ha.ag_id
                 AND TRUNC (c.data, 'mm') = h.data
                 AND h.id = :route
                 AND ha.head_id = h.id
                 AND s.tn = h.tn
                 AND ha.vv = 0) cpp,
         (SELECT *
            FROM routes_body1
           WHERE head_id = :route AND vv = 0) rb,
         routes_tp rt,
         merch_report_ok o
   WHERE     cpp.kodtp = rb.kodtp(+)
         AND cpp.ag_id = rb.ag_id(+)
         AND cpp.dm = rb.day_num(+)
         AND cpp.kodtp = rt.kodtp
         AND rt.head_id = :route
         AND rt.vv = 0
         AND :route = o.head_id(+)
         AND cpp.data = o.dt(+)
         AND cpp.kodtp = :tp
         AND cpp.ag_id = :ag
ORDER BY tz_oblast,
         net_name,
         ur_tz_name,
         tz_address,
         kodtp,
         ag_name,
         dm