/* Formatted on 25/11/2015 12:58:46 PM (QP5 v5.252.13127.32867) */
  SELECT id_net id, net_name name, c.chain checked
    FROM ms_nets n, MERCH_REPORT_CAL_CHAINS c
   WHERE n.id_net = c.chain(+) AND :id = c.parent(+)
ORDER BY net_name