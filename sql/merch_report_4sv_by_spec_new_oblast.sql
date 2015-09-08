/* Formatted on 01/09/2015 16:22:08 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT tz_oblast oblast, h_tz_oblast h_oblast
    FROM cpp
   WHERE tz_oblast IS NOT NULL
ORDER BY tz_oblast