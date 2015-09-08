/* Formatted on 09/12/2014 21:40:57 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT c.tz_oblast, S.TN
    FROM cpp c,
         (SELECT *
            FROM mkk_oblast
           WHERE tn = :tn) s
   WHERE c.tz_oblast IS NOT NULL AND c.tz_oblast = s.oblast(+)
ORDER BY c.tz_oblast