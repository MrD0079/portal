/* Formatted on 07.06.2012 9:40:19 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT
         n.*,
         cpp.id_net,
         cpp.ur_tz_name,
         cpp.tz_address,
         cpp.kodtp,
         (SELECT COUNT (*)
            FROM merch_spec_head
           WHERE id_net = n.id_net AND kod_tp = cpp.kodtp AND ag_id = :ag)
            c,
         (SELECT id
            FROM merch_spec_head
           WHERE id_net = n.id_net AND kod_tp = cpp.kodtp AND ag_id = :ag)
            head_id
    FROM ms_nets n, cpp
   WHERE     N.id_net = cpp.id_net
         AND DECODE (:net, 0, n.id_net, :net) = n.id_net
         AND cpp.id_net IS NOT NULL
         AND cpp.ur_tz_name IS NOT NULL
         AND cpp.kodtp IS NOT NULL
ORDER BY net_name,
         ur_tz_name,
         tz_address,
         kodtp