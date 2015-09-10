/* Formatted on 06.08.2012 14:51:20 (QP5 v5.163.1008.3004) */
  SELECT z.*
    FROM (SELECT dzc.id,
                 TO_CHAR (dzc.created, 'dd.mm.yyyy hh24:mi:ss') created,
                 TO_CHAR (dzc.created, 'dd.mm.yyyy') created_dt,
                 dzc.comm,
                 fn_getname (dzc.tn) creator,
                 fn_getname (dzc.recipient) recipient,
                 fn_getdolgn (dzc.tn) creator_pos,
                 fn_getdolgn (dzc.recipient) recipient_pos,
                 (SELECT tn
                    FROM dzc_accept
                   WHERE dzc_id = dzc.id
                         AND accept_order =
                                (SELECT MIN (accept_order)
                                   FROM dzc_accept
                                  WHERE dzc_id = dzc.id AND accepted = 0))
                    current_acceptor_tn,
                 fn_getname (
                    (SELECT tn
                       FROM dzc_accept
                      WHERE dzc_id = dzc.id
                            AND accept_order =
                                   (SELECT MIN (accept_order)
                                      FROM dzc_accept
                                     WHERE dzc_id = dzc.id AND accepted = 0)))
                    current_acceptor_name,
                 dzc_accept.tn acceptor_tn,
                 fn_getname ( dzc_accept.tn) acceptor_name,
                 dzc_accept.accepted,
                 dzc_accept.failure,
                 dzc_accept.accept_order,
                 dzcat.name accepted_name,
                 DECODE (dzc_accept.accepted,
                         0, NULL,
                         TO_CHAR (dzc_accept.lu, 'dd.mm.yyyy hh24:mi:ss'))
                    accepted_date,
                 DECODE ( (SELECT COUNT (*)
                             FROM dzc_accept
                            WHERE dzc_id = dzc.id AND accepted = 2),
                         0, 0,
                         1)
                    deleted,
                 f.fn,
                 (SELECT id
                    FROM dzc_accept
                   WHERE dzc_id = dzc.id
                         AND accept_order =
                                (SELECT MIN (accept_order)
                                   FROM dzc_accept
                                  WHERE dzc_id = dzc.id AND accepted = 0))
                    current_accept_id
            FROM dzc,
                 dzc_accept,
                 accept_types dzcat,
                 dzc_files f
           WHERE     dzc.id = dzc_accept.dzc_id
                 AND dzc_accept.accepted = dzcat.id
                 AND dzc.id = f.dzc_id(+)
                 AND dzc.id = :id) z
ORDER BY id, accept_order