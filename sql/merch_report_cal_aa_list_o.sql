/* Formatted on 14/08/2015 19:05:35 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT h_tz_oblast, tz_oblast
    FROM cpp
   WHERE tz_oblast IS NOT NULL
ORDER BY tz_oblast