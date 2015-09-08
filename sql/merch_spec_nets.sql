  SELECT distinct n.*
    FROM ms_nets n, cpp
   WHERE     N.id_net = cpp.id_net
         and cpp.id_net is not null and cpp.ur_tz_name is not null and cpp.kodtp is not null
ORDER BY net_name