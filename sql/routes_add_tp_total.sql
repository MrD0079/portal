/* Formatted on 20.08.2012 16:49:01 (QP5 v5.163.1008.3004) */
SELECT COUNT (*) c
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
 WHERE cpp.kodtp = rb.kodtp(+) AND rb.id IS NOT NULL