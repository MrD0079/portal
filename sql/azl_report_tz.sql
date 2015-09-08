/* Formatted on 13.02.2013 15:13:58 (QP5 v5.163.1008.3004) */
  SELECT tz.id, tz.addr, n.name
    FROM azl_tz tz, azl_nets n
   WHERE tz.contr_avk = :id AND n.id = tz.nets
ORDER BY n.name, tz.addr