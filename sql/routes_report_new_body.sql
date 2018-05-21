/* Formatted on 17.05.2018 16:09:46 (QP5 v5.252.13127.32867) */
  SELECT cpp.tz_oblast,
         (SELECT net_name
            FROM ms_nets
           WHERE id_net = cpp.id_net)
            net_name,
         ur_tz_name,
         tz_address,
         cpp.kodtp,
         rb.id,
         rb.day_enabled_mr,
         rb.day_time_mr,
         /*rb.day_enabled_f,
         rb.day_time_f,*/
         a.name ag_name,
         rb.ag_id
    FROM cpp,
         (SELECT *
            FROM svms_oblast
           WHERE tn = (SELECT tn
                         FROM routes_head
                        WHERE id = :route)) s,
         routes_body1 rb,
         routes_agents a,
         routes_tp rt
   WHERE     cpp.tz_oblast = s.oblast
         AND cpp.kodtp = rb.kodtp(+)
         AND rb.head_id(+) = :route
         AND cpp.kodtp = rt.kodtp
         AND rt.head_id = :route
         AND A.ID = rb.ag_id
         AND rb.day_num = :day
         AND (rb.day_enabled_mr = 1 /*OR rb.day_enabled_f = 1*/
                                   )
         AND rt.vv = 0
         AND rb.vv = 0
ORDER BY cpp.tz_oblast,
         net_name,
         cpp.ur_tz_name,
         cpp.tz_address,
         /*cpp.fio_eta,*/
         cpp.kodtp,
         ag_name