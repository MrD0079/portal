/* Formatted on 03.04.2014 16:47:14 (QP5 v5.227.12220.39724) */
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
         (SELECT COUNT (*)
            FROM merch_spec_body
           WHERE head_id =
                    (SELECT id
                       FROM merch_spec_head
                      WHERE     id_net = n.id_net
                            AND kod_tp = cpp.kodtp
                            AND ag_id = :ag
                            AND sd =
                                   (SELECT MAX (sd)
                                      FROM merch_spec_head
                                     WHERE     id_net = n.id_net
                                           AND kod_tp = cpp.kodtp
                                           AND ag_id = :ag)))
            cb,
         (SELECT id
            FROM merch_spec_head
           WHERE     id_net = n.id_net
                 AND kod_tp = cpp.kodtp
                 AND ag_id = :ag
                 AND sd =
                        (SELECT MAX (sd)
                           FROM merch_spec_head
                          WHERE     id_net = n.id_net
                                AND kod_tp = cpp.kodtp
                                AND ag_id = :ag))
            head_id,
         (SELECT TO_CHAR (MAX (sd), 'dd.mm.yyyy')
            FROM merch_spec_head
           WHERE id_net = n.id_net AND kod_tp = cpp.kodtp AND ag_id = :ag)
            sd
    FROM ms_nets n, cpp
   WHERE     N.id_net = cpp.id_net
         AND DECODE (:net, 0, n.id_net, :net) = n.id_net
         AND DECODE (:oblast, '0', cpp.h_tz_oblast, :oblast) = cpp.h_tz_oblast
         AND cpp.id_net IS NOT NULL
         AND cpp.ur_tz_name IS NOT NULL
         AND cpp.kodtp IS NOT NULL
ORDER BY net_name,
         ur_tz_name,
         tz_address,
         kodtp