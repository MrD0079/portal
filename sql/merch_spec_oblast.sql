/* Formatted on 27.02.2014 22:10:52 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT cpp.h_tz_oblast, cpp.tz_oblast
    FROM cpp
   WHERE     cpp.id_net IS NOT NULL
         AND cpp.ur_tz_name IS NOT NULL
         AND cpp.kodtp IS NOT NULL
ORDER BY cpp.tz_oblast