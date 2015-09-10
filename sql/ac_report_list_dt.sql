/* Formatted on 30.04.2014 9:08:38 (QP5 v5.227.12220.39724) */
  SELECT ac.id, TO_CHAR (ac.dt, 'dd.mm.yyyy') dt, u.fio
    FROM ac, user_list u
   WHERE     TO_CHAR (ac.dt, 'yyyy') = :y
         AND u.tn = ac.init_tn
         AND u.dpt_id = :dpt_id
         AND NVL (
                (SELECT accepted
                   FROM ac_accept
                  WHERE     ac_id = ac.id
                        AND accept_order =
                               DECODE (
                                  NVL (
                                     (SELECT MAX (accept_order)
                                        FROM ac_accept
                                       WHERE     ac_id = ac.id
                                             AND accepted = 2),
                                     0),
                                  0, (SELECT MAX (accept_order)
                                        FROM ac_accept
                                       WHERE ac_id = ac.id),
                                  (SELECT MAX (accept_order)
                                     FROM ac_accept
                                    WHERE ac_id = ac.id AND accepted = 2))),
                0) = 1
ORDER BY ac.dt, u.fio