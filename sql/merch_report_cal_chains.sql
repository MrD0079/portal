/* Formatted on 06.02.2017 13:48:25 (QP5 v5.252.13127.32867) */
  SELECT id_net id, net_name name, c.chain checked
    FROM ms_nets n, MERCH_REPORT_CAL_CHAINS c
   WHERE n.id_net = c.chain(+) AND :id = c.parent(+) AND n.net_name IS NOT NULL
ORDER BY net_name