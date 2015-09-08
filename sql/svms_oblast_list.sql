/* Formatted on 12.03.2012 13:53:06 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT c.tz_oblast, S.TN
    FROM cpp c,
         (SELECT *
            FROM svms_oblast
           WHERE tn = :tn) s
   WHERE c.tz_oblast IS NOT NULL AND c.tz_oblast = s.oblast(+)
ORDER BY c.tz_oblast