/* Formatted on 21.07.2014 17:42:27 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT cpp.tz_oblast,
                  (SELECT net_name
                     FROM ms_nets
                    WHERE id_net = cpp.id_net)
                     net_name,
                  ur_tz_name,
                  tz_address,
                  cpp.kodtp
    FROM routes_head rh, routes_tp rp, cpp
   WHERE     TRUNC (rh.data, 'mm') BETWEEN TRUNC (TO_DATE (:sd, 'dd/mm/yyyy'),
                                                  'mm')
                                       AND TRUNC (TO_DATE (:ed, 'dd/mm/yyyy'),
                                                  'mm')
         AND (   tn IN (SELECT slave
                               FROM full
                              WHERE master = :tn)
              OR (SELECT is_ma
                    FROM user_list
                   WHERE tn = :tn) = 1 OR (SELECT is_admin
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND rh.id = rp.head_id
         AND rp.kodtp = cpp.kodtp
         AND DECODE (:nets, 0, 0, cpp.id_net) = DECODE (:nets, 0, 0, :nets)
         AND DECODE (:oblast, '0', '0', cpp.tz_oblast) =
                DECODE (:oblast, '0', '0', :oblast)
         AND DECODE (:city, '0', '0', cpp.city) =
                DECODE (:city, '0', '0', :city)
ORDER BY tz_oblast,
         net_name,
         ur_tz_name,
         tz_address,
         kodtp