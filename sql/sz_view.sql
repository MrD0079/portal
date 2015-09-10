/* Formatted on 06.08.2012 14:51:20 (QP5 v5.163.1008.3004) */
  SELECT z.*
    FROM (SELECT sz.id,
                 TO_CHAR (sz.created, 'dd.mm.yyyy hh24:mi:ss') created,
                 TO_CHAR (sz.created, 'dd.mm.yyyy') created_dt,
                 sz.head,
                 sz.body,
                 fn_getname (sz.tn) creator,
                 fn_getname (sz.recipient) recipient,
                 fn_getdolgn (sz.tn) creator_pos,
                 fn_getdolgn (sz.recipient) recipient_pos,
                 (SELECT tn
                    FROM sz_accept
                   WHERE sz_id = sz.id
                         AND accept_order =
                                (SELECT MIN (accept_order)
                                   FROM sz_accept
                                  WHERE sz_id = sz.id AND accepted = 0))
                    current_acceptor_tn,
                 fn_getname (
                    (SELECT tn
                       FROM sz_accept
                      WHERE sz_id = sz.id
                            AND accept_order =
                                   (SELECT MIN (accept_order)
                                      FROM sz_accept
                                     WHERE sz_id = sz.id AND accepted = 0)))
                    current_acceptor_name,
                 sz_accept.tn acceptor_tn,
                 fn_getname ( sz_accept.tn) acceptor_name,
                 sz_accept.accepted,
                 sz_accept.failure,
                 sz_accept.accept_order,
                 szat.name accepted_name,
                 DECODE (sz_accept.accepted,
                         0, NULL,
                         TO_CHAR (sz_accept.lu, 'dd.mm.yyyy hh24:mi:ss'))
                    accepted_date,
                 DECODE ( (SELECT COUNT (*)
                             FROM sz_accept
                            WHERE sz_id = sz.id AND accepted = 2),
                         0, 0,
                         1)
                    deleted,
                 f.fn,
                 (SELECT id
                    FROM sz_accept
                   WHERE sz_id = sz.id
                         AND accept_order =
                                (SELECT MIN (accept_order)
                                   FROM sz_accept
                                  WHERE sz_id = sz.id AND accepted = 0))
                    current_accept_id
            FROM sz,
                 sz_accept,
                 accept_types szat,
                 sz_files f
           WHERE     sz.id = sz_accept.sz_id
                 AND sz_accept.accepted = szat.id
                 AND sz.id = f.sz_id(+)
                 AND sz.id = :id) z
ORDER BY id, accept_order