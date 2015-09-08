/* Formatted on 11.02.2013 10:19:15 (QP5 v5.163.1008.3004) */
  SELECT tz.id, tz.addr, n.name
    FROM atd_tz tz, atd_nets n
   WHERE tz.contr_ag = :id AND n.id = tz.nets
ORDER BY n.name, tz.addr