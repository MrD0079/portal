/* Formatted on 14/08/2015 19:07:12 (QP5 v5.227.12220.39724) */
  SELECT id_net, net_name
    FROM ms_nets
   WHERE net_name IS NOT NULL
ORDER BY net_name