/* Formatted on 20.09.2012 10:05:22 (QP5 v5.163.1008.3004) */
  SELECT fn_getname ( tn) acceptor
    FROM dzc_accept
   WHERE dzc_id = :id
ORDER BY accept_order