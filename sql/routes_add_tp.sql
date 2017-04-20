/* Formatted on 18.04.2017 15:39:43 (QP5 v5.252.13127.32867) */
  SELECT cpp.tz_oblast,
         (SELECT net_name
            FROM ms_nets
           WHERE id_net = cpp.id_net)
            net_name,
         ur_tz_name,
         tz_address,
         cpp.kodtp,
         rb.id,
         DECODE (rb.id, NULL, NULL, 1) tp_enabled,
         DECODE (svmsok.kodtp, NULL, 0, 1) svmsok
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
           WHERE head_id = :route AND vv = 0) rb,
         (SELECT DISTINCT b.kodtp
            FROM routes_head h,
                 routes_body1 b,
                 calendar c,
                 merch_report mr,
                 merch_report_ok o
           WHERE     h.id = b.head_id
                 AND h.data = TRUNC (c.data, 'mm')
                 AND c.dm = b.day_num
                 AND b.id = mr.rb_id
                 AND c.data = mr.dt
                 AND h.id = o.head_id
                 AND c.data = o.dt
                 AND h.id = :route
                 AND b.vv = 0) svmsok
   WHERE cpp.kodtp = rb.kodtp(+) AND cpp.kodtp = svmsok.kodtp(+)
ORDER BY tz_oblast,
         net_name,
         ur_tz_name,
         tz_address,
         kodtp