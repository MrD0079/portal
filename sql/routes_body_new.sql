/* Formatted on 16.01.2014 11:08:40 (QP5 v5.227.12220.39724) */
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
         rb.DAY_TIME_MR/*,
         rb.DAY_ENABLED_F,
         rb.DAY_TIME_F*/
    FROM (SELECT cpp1.*,
                 a.id ag_id,
                 a.name ag_name,
                 c.dm,
                 c.dw,
                 c.dwt,
                 c.is_wd
            FROM cpp cpp1,
                 (SELECT *
                    FROM svms_oblast
                   WHERE tn = (SELECT tn
                                 FROM routes_head
                                WHERE id = :route)) s,
                 (SELECT *
                    FROM routes_head_agents
                   WHERE HEAD_ID = :route AND vv = 0) ha,
                 routes_agents a,
                 calendar c
           WHERE     cpp1.tz_oblast = s.oblast
                 AND A.ID = HA.AG_ID
                 AND TRUNC (c.data, 'mm') = (SELECT data
                                               FROM routes_head
                                              WHERE id = :route)) cpp,
         (SELECT *
            FROM routes_body1
           WHERE head_id = :route AND vv = 0) rb,
         routes_tp rt
   WHERE     cpp.kodtp = rb.kodtp(+)
         AND cpp.ag_id = rb.ag_id(+)
         AND cpp.dm = rb.day_num(+)
         AND cpp.kodtp = rt.kodtp
         AND rt.head_id = :route
         AND rt.vv = 0
ORDER BY tz_oblast,
         net_name,
         ur_tz_name,
         tz_address,
         kodtp,
         ag_name,
         dm