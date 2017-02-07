/* Formatted on 06.02.2017 13:45:28 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT cpp.tz_oblast name, cpp.h_tz_oblast id, r.region checked
    FROM cpp, MERCH_REPORT_CAL_REGIONS r
   WHERE     cpp.h_tz_oblast = r.region(+)
         AND :id = r.parent(+)
         AND cpp.h_tz_oblast IS NOT NULL
ORDER BY cpp.tz_oblast