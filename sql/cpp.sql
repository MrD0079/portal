/* Formatted on 27.07.2012 10:43:24 (QP5 v5.163.1008.3004) */
  SELECT c.*, n.net_name, n.id_net n_id_net
    FROM cpp c, ms_nets n
   WHERE n.id_net(+) = NVL (c.id_net, 0)
         AND DECODE (:flt_id_net, 0, NVL (c.id_net, 0), :flt_id_net) =
                NVL (c.id_net, 0)
         AND DECODE (:flt_tz_oblast,
                     '', NVL (c.tz_oblast, ' '),
                     :flt_tz_oblast) = NVL (c.tz_oblast, ' ')
ORDER BY tz_oblast nulls first, ur_tz_name, tz_address