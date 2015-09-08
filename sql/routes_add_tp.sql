/* Formatted on 20.08.2012 16:48:40 (QP5 v5.163.1008.3004) */
  SELECT cpp.tz_oblast,
         (SELECT net_name
            FROM ms_nets
           WHERE id_net = cpp.id_net)
            net_name,
         ur_tz_name,
         tz_address,
         cpp.kodtp,
         DECODE (rb.id, NULL, NULL, 1) tp_enabled,
         rb.ID
    FROM (SELECT cpp1.*
            FROM cpp cpp1,
                 (SELECT *
                    FROM svms_oblast
                   WHERE tn = (SELECT tn
                                 FROM routes_head
                                WHERE id = :route)) s
           WHERE cpp1.tz_oblast = s.oblast) cpp,
         (SELECT *
            FROM routes_tp
           WHERE head_id = :route AND vv = 0) rb
   WHERE cpp.kodtp = rb.kodtp(+)
ORDER BY tz_oblast,
         net_name,
         ur_tz_name,
         tz_address,
         kodtp