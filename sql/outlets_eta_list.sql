/* Formatted on 01.03.2012 21:13:19 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT cpp.fio_eta eta
    FROM nets n, coveringpointspos cpp
   WHERE     N.SW_KOD = cpp.id_net
         AND n.tn_mkk IN (SELECT slave
                               FROM full
                              WHERE master = :tn)
         AND fio_eta IS NOT NULL
ORDER BY fio_eta