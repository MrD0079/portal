/* Formatted on 09.07.2012 9:54:28 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT n.id_net, n.net_name
    FROM ms_nets n, cpp cpp1
   WHERE /*TRUNC (cpp1.data, 'mm') = TRUNC (TO_DATE (:ed, 'dd/mm/yyyy'), 'mm')
         AND */n.id_net = cpp1.id_net
ORDER BY n.net_name