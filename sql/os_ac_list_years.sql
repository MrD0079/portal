/* Formatted on 30.04.2014 9:55:48 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT c.y
    FROM ac, user_list u, calendar c
   WHERE     ac.dt = c.data
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
ORDER BY c.y DESC