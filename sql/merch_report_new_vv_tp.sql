/* Formatted on 02.12.2013 11:23:12 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT cpp.tz_oblast,
                  (SELECT net_name
                     FROM ms_nets
                    WHERE id_net = cpp.id_net)
                     net_name,
                  ur_tz_name,
                  tz_address,
                  cpp.kodtp/*,
                  DECODE (r.id, NULL, NULL, 1) tp_enabled,
                  r.ID*/                                               /*,rr.**/
    FROM (SELECT cpp1.*
            FROM cpp cpp1,
                 (SELECT *
                    FROM svms_oblast
                   WHERE tn = (SELECT tn
                                 FROM routes_head
                                WHERE id = :route)) s
           WHERE cpp1.tz_oblast = s.oblast) cpp,
         (SELECT rb1.*
            FROM routes_tp rb1, routes_head h
           WHERE     h.id = rb1.head_id
                 AND h.data = (SELECT data
                                 FROM routes_head
                                WHERE id = :route)
                 AND h.tn = (SELECT tn
                               FROM routes_head
                              WHERE id = :route)) r /*,
          ms_rep_routes rr*/
   WHERE cpp.kodtp = r.kodtp(+)
/*AND rr.rh_data = (SELECT data
                    FROM routes_head
                   WHERE id = :route)
AND cpp.kodtp = rr.rb_kodtp*/
ORDER BY tz_oblast,
         net_name,
         ur_tz_name,
         tz_address,
         kodtp