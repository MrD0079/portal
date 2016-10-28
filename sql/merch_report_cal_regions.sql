/* Formatted on 25/11/2015 12:58:43 PM (QP5 v5.252.13127.32867) */
  SELECT DISTINCT cpp.tz_oblast name, cpp.h_tz_oblast id, r.region checked
    FROM cpp, MERCH_REPORT_CAL_REGIONS r
   WHERE cpp.h_tz_oblast = r.region(+) AND :id = r.parent(+)
ORDER BY cpp.tz_oblast