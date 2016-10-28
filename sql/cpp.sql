/* Formatted on 12/16/2015 5:06:58  (QP5 v5.252.13127.32867) */
  SELECT c.*, n.net_name, n.id_net n_id_net
    FROM cpp c, ms_nets n
   WHERE     n.id_net(+) = NVL (c.id_net, 0)
         AND DECODE ( :id, 0, c.id, :id) = c.id
         AND DECODE ( :flt_id_net, 0, NVL (c.id_net, 0), :flt_id_net) =
                NVL (c.id_net, 0)
         AND DECODE ( :flt_tz_oblast,
                     '', NVL (c.tz_oblast, ' '),
                     :flt_tz_oblast) = NVL (c.tz_oblast, ' ')
ORDER BY tz_oblast NULLS FIRST, ur_tz_name, tz_address