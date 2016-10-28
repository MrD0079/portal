/* Formatted on 27/05/2016 17:11:53 (QP5 v5.252.13127.32867) */
  SELECT r.tp_kod id, r.tp_name || ' ' || r.address name
    FROM nets n, tp_nets_kk tpn, routes r
   WHERE     tpn.net_kod = n.sw_kod
         AND n.id_net = :id_net
         AND tpn.tp_kod = r.tp_kod
ORDER BY name