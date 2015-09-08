/* Formatted on 22.08.2012 14:30:59 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT c.tz_oblast, S.login
    FROM cpp c,
         (SELECT *
            FROM routes_logins_oblast
           WHERE login = :login) s
   WHERE c.tz_oblast IS NOT NULL AND c.tz_oblast = s.oblast(+)
ORDER BY c.tz_oblast