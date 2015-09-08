/* Formatted on 12.06.2014 10:41:11 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT
         v.id,
         TO_CHAR (v.created, 'dd.mm.yyyy hh24:mi:ss') created,
         TO_CHAR (v.v_from, 'dd.mm.yyyy') v_from,
         TO_CHAR (v.v_to, 'dd.mm.yyyy') v_to,
         v.v_from vv_from,
         v.v_to vv_to,
         v.tn,
         u.fio,
         v.replacement,
         v.replacement_mob,
         v.replacement_mail,
         DECODE (v.replacement, NULL, v.replacement_fio_eta, u1.fio)
            replacement_fio,
         v.sz_id,
         /*f.full,*/
         (SELECT sz_accept_types.name1
            FROM sz_accept, sz_accept_types
           WHERE     sz_id = v.sz_id
                 AND accepted = sz_accept_types.id(+)
                 AND accept_order =
                        DECODE (
                           NVL (
                              (SELECT accept_order
                                 FROM sz_accept
                                WHERE sz_id = v.sz_id AND accepted = 464262),
                              0),
                           0, (SELECT MAX (accept_order)
                                 FROM sz_accept
                                WHERE sz_id = v.sz_id),
                           (SELECT accept_order
                              FROM sz_accept
                             WHERE sz_id = v.sz_id AND accepted = 464262)))
            sz_status,
         (SELECT accepted
            FROM sz_accept
           WHERE     sz_id = v.sz_id
                 AND accept_order =
                        DECODE (
                           NVL (
                              (SELECT accept_order
                                 FROM sz_accept
                                WHERE sz_id = v.sz_id AND accepted = 464262),
                              0),
                           0, (SELECT MAX (accept_order)
                                 FROM sz_accept
                                WHERE sz_id = v.sz_id),
                           (SELECT accept_order
                              FROM sz_accept
                             WHERE sz_id = v.sz_id AND accepted = 464262)))
            sz_status_id,
         (SELECT failure
            FROM sz_accept
           WHERE     sz_id = v.sz_id
                 AND accept_order =
                        DECODE (
                           NVL (
                              (SELECT accept_order
                                 FROM sz_accept
                                WHERE sz_id = v.sz_id AND accepted = 464262),
                              0),
                           0, (SELECT MAX (accept_order)
                                 FROM sz_accept
                                WHERE sz_id = v.sz_id),
                           (SELECT accept_order
                              FROM sz_accept
                             WHERE sz_id = v.sz_id AND accepted = 464262)))
            failure,
         DECODE ( (SELECT COUNT (*)
                     FROM sz_accept
                    WHERE sz_id = v.sz_id AND accepted <> 464260),
                 0, 1,
                 0)
            sz_not_seen
    FROM vacation v,
         /*full f,*/
         user_list u,
         user_list u1,sz
   WHERE     v.sz_id=sz.id
             AND /*f.master = :tn
         AND v.tn = f.slave
         AND */v.tn=:tn
         AND u.tn = v.tn
         AND u1.tn(+) = v.replacement
         AND NVL (
                (SELECT accepted
                   FROM sz_accept
                  WHERE     sz_id = v.sz_id
                        AND accept_order =
                               DECODE (
                                  NVL (
                                     (SELECT accept_order
                                        FROM sz_accept
                                       WHERE     sz_id = v.sz_id
                                             AND accepted = 464262),
                                     0),
                                  0, (SELECT MAX (accept_order)
                                        FROM sz_accept
                                       WHERE sz_id = v.sz_id),
                                  (SELECT accept_order
                                     FROM sz_accept
                                    WHERE sz_id = v.sz_id AND accepted = 464262))),
                0) /*<> 464261*/ in (464260,464262)
ORDER BY vv_from DESC, vv_to DESC, u.fio