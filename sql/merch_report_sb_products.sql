/* Formatted on 14/11/2014 12:29:48 (QP5 v5.227.12220.39724) */
  SELECT sb.*
    FROM routes_head h,
         cpp,
         svms_oblast s,
         routes_tp rt,
         ms_nets n,
         (SELECT DISTINCT head_id, kodtp, day_num FROM routes_body1) rb,
         calendar c,
         merch_report_sb sb
   WHERE     h.id = :route
         AND s.tn = h.tn
         AND rt.head_id = h.id
         AND rb.head_id = h.id
         AND rb.kodtp = rt.kodtp
         AND cpp.kodtp = rt.kodtp
         AND rt.kodtp = :kodtp
         AND cpp.tz_oblast = s.oblast
         AND n.id_net = cpp.id_net
         AND rb.day_num = c.dm
         AND TRUNC (c.data, 'mm') = h.data
         AND c.data = TO_DATE (:data, 'dd.mm.yyyy')
         AND sb.head_id = rt.head_id
         AND sb.kod_tp = rt.kodtp
         AND sb.dt = c.data
ORDER BY sb.id
