/* Formatted on 27.02.2014 22:20:19 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT
         n.*,
         cpp.id_net,
         cpp.ur_tz_name,
         cpp.tz_address,
         cpp.kodtp
    FROM ms_nets n, cpp
   WHERE     N.id_net = cpp.id_net
         AND DECODE (:net, 0, n.id_net, :net) = n.id_net
         AND DECODE (:oblast, '0', cpp.h_tz_oblast, :oblast) = cpp.h_tz_oblast
         AND cpp.id_net IS NOT NULL
         AND cpp.ur_tz_name IS NOT NULL
         AND cpp.kodtp IS NOT NULL
ORDER BY --net_name,
         --ur_tz_name,
         tz_address,
         kodtp