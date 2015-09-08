/* Formatted on 06.06.2012 15:54:40 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT n.*,
                  (SELECT COUNT (*)
                     FROM merch_spec_head
                    WHERE id_net = n.id_net AND ag_id = :ag)
                     c
    FROM ms_nets n, cpp
   WHERE     N.id_net = cpp.id_net
         AND DECODE (:net, 0, n.id_net, :net) = n.id_net
         AND cpp.id_net IS NOT NULL
         AND cpp.ur_tz_name IS NOT NULL
         AND cpp.kodtp IS NOT NULL
ORDER BY net_name