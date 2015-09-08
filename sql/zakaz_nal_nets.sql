/* Formatted on 11.01.2013 13:59:12 (QP5 v5.163.1008.3004) */
  SELECT id_net,
         net_name,
         tn_mkk,
         tn_rmkk
    FROM nets n
   WHERE :tn NOT IN (tn_mkk, tn_rmkk) AND id_status = 3
ORDER BY n.net_name