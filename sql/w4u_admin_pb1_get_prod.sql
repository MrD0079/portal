/* Formatted on 24.04.2013 9:13:24 (QP5 v5.163.1008.3004) */
  SELECT p.groupname, p.h_groupname, t.ttqtybaseperiod
    FROM (SELECT *
            FROM w4u_transit1
           WHERE m = TO_DATE (:dt, 'dd.mm.yyyy') AND h_fio_eta = :h_fio_eta) t,
         w4u_lpg p,
         w4u_vp1 v
   WHERE p.h_groupname = t.h_groupname(+) AND v.m = TO_DATE (:dt, 'dd.mm.yyyy') AND v.h_groupname = p.h_groupname
ORDER BY p.groupname