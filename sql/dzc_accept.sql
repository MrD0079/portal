/* Formatted on 11/09/2015 12:34:18 (QP5 v5.227.12220.39724) */
  SELECT z.*, DECODE (z.current_acceptor_tn, :tn, 1, 0) allow_status_change
    FROM (SELECT dzc.id,
                 TO_CHAR (dzc.created, 'dd.mm.yyyy hh24:mi:ss') created,
                 dzc.comm,
                 rcy.currencyname,
                 rcs.customername,
                 rds.departmentname,
                 rps.statname,
                 rss.producttype,
                 dzc.summa,
                 c.mt || ' ' || c.y dt,
                 dzc.tn creator_tn,
                 fn_getname (dzc.tn) creator,
                 fn_getname (dzc.recipient) recipient,
                 NVL (
                    (SELECT accepted
                       FROM dzc_accept
                      WHERE     dzc_id = dzc.id
                            AND accept_order =
                                   DECODE (
                                      NVL (
                                         (SELECT MAX (accept_order)
                                            FROM dzc_accept
                                           WHERE     dzc_id = dzc.id
                                                 AND accepted = 2),
                                         0),
                                      0, (SELECT MAX (accept_order)
                                            FROM dzc_accept
                                           WHERE dzc_id = dzc.id /* AND accepted <> 0*/
                                                                ),
                                      (SELECT MAX (accept_order)
                                         FROM dzc_accept
                                        WHERE dzc_id = dzc.id AND accepted = 2))),
                    0)
                    current_status,
                 (SELECT tn
                    FROM dzc_accept
                   WHERE     dzc_id = dzc.id
                         AND accept_order =
                                (SELECT MIN (accept_order)
                                   FROM dzc_accept
                                  WHERE dzc_id = dzc.id AND accepted = 0))
                    current_acceptor_tn,
                 fn_getname (
                    (SELECT tn
                       FROM dzc_accept
                      WHERE     dzc_id = dzc.id
                            AND accept_order =
                                   (SELECT MIN (accept_order)
                                      FROM dzc_accept
                                     WHERE dzc_id = dzc.id AND accepted = 0)))
                    current_acceptor_name,
                 dzc_accept.tn acceptor_tn,
                 fn_getname (dzc_accept.tn) acceptor_name,
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
                   WHERE     dzc_id = dzc.id
                         AND accept_order =
                                (SELECT MIN (accept_order)
                                   FROM dzc_accept
                                  WHERE dzc_id = dzc.id AND accepted = 0))
                    current_accept_id,
                 (SELECT accept_order
                    FROM dzc_accept
                   WHERE     dzc_id = dzc.id
                         AND accept_order =
                                (SELECT MIN (accept_order)
                                   FROM dzc_accept
                                  WHERE dzc_id = dzc.id AND accepted = 0))
                    current_accept_order,
                 (SELECT id
                    FROM dzc_accept
                   WHERE dzc_id = dzc.id AND tn = :tn)
                    my_dzc_accept,
                 (SELECT accept_order
                    FROM dzc_accept
                   WHERE dzc_id = dzc.id AND tn = :tn)
                    my_accept_order,
                 fn_getname (a.tn) chater,
                 a.text,
                 a.lu chat_time_d,
                 TO_CHAR (a.lu, 'dd.mm.yyyy hh24:mi:ss') chat_time,
                 a.id chat_id,
                 (SELECT DECODE (COUNT (tn), 0, 0, 1) c
                    FROM dzc_accept
                   WHERE     dzc_id = dzc.id
                         AND accept_order >=
                                ( (SELECT accept_order
                                     FROM dzc_accept
                                    WHERE     dzc_id = dzc.id
                                          AND tn =
                                                 (SELECT tn
                                                    FROM dzc_accept
                                                   WHERE     dzc_id = dzc.id
                                                         AND accept_order =
                                                                (SELECT MIN (
                                                                           accept_order)
                                                                   FROM dzc_accept
                                                                  WHERE     dzc_id =
                                                                               dzc.id
                                                                        AND accepted =
                                                                               0))))
                         AND tn = :tn)
                    allow_text,
                 u.pos_name creator_pos_name,
                 u1.pos_name acceptor_pos_name,
                 u2.pos_name recipient_pos_name,
                 u.department_name creator_department_name,
                 u1.department_name acceptor_department_name,
                 u2.department_name recipient_department_name,
                 u.region_name
            FROM dzc,
                 dzc_accept,
                 accept_types dzcat,
                 dzc_files f,
                 user_list u,
                 user_list u1,
                 user_list u2,
                 dzc_chat a,
                 DZC_REFCURRENCY rcy,
                 DZC_REFCUSTOMERS rcs,
                 DZC_REFDEPARTMENTS rds,
                 DZC_REFSTATESOFEXPENCES rps,
                 DZC_REFPRODUCTTYPES rss,
                 calendar c
           WHERE     dzc.tn = u.tn
                 AND dzc_accept.tn = u1.tn
                 AND dzc.recipient = u2.tn
                 AND dzc.id = dzc_accept.dzc_id(+)
                 AND dzc_accept.accepted = dzcat.id(+)
                 AND a.dzc_id(+) = dzc.id
                 AND dzc.id = f.dzc_id(+)
                 AND (   (SELECT tn
                            FROM dzc_accept
                           WHERE     dzc_id = dzc.id
                                 AND accept_order =
                                        (SELECT MIN (accept_order)
                                           FROM dzc_accept
                                          WHERE     dzc_id = dzc.id
                                                AND accepted = 0)) = :tn
                      OR dzc.tn = :tn
                      OR ( (SELECT accept_order
                              FROM dzc_accept
                             WHERE     dzc_id = dzc.id
                                   AND accept_order =
                                          (SELECT MIN (accept_order)
                                             FROM dzc_accept
                                            WHERE     dzc_id = dzc.id
                                                  AND accepted = 0)) >=
                             (SELECT accept_order
                                FROM dzc_accept
                               WHERE dzc_id = dzc.id AND tn = :tn)))
                 AND DECODE ( (SELECT COUNT (*)
                                 FROM dzc_accept
                                WHERE dzc_id = dzc.id AND accepted = 2),
                             0, 0,
                             1) = 0
                 AND NVL (
                        (SELECT accepted
                           FROM dzc_accept
                          WHERE     dzc_id = dzc.id
                                AND accept_order =
                                       DECODE (
                                          NVL (
                                             (SELECT MAX (accept_order)
                                                FROM dzc_accept
                                               WHERE     dzc_id = dzc.id
                                                     AND accepted = 2),
                                             0),
                                          0, (SELECT MAX (accept_order)
                                                FROM dzc_accept
                                               WHERE dzc_id = dzc.id /* AND accepted <> 0*/
                                                                    ),
                                          (SELECT MAX (accept_order)
                                             FROM dzc_accept
                                            WHERE     dzc_id = dzc.id
                                                  AND accepted = 2))),
                        0) <> 1
                 AND dzc.CURRENCYCODE = rcy.CURRENCYCODE(+)
                 AND dzc.CUSTOMERID = rcs.CUSTOMERID(+)
                 AND dzc.DEPARTMENTID = rds.DEPARTMENTID(+)
                 AND dzc.STATID = rps.STATID(+)
                 AND dzc.H_PRODUCTTYPE = rss.H_PRODUCTTYPE(+)
                 AND dzc.dt = c.data(+)) z
   WHERE DECODE (:wait4myaccept, 0, :tn, 0) =
            DECODE (:wait4myaccept, 0, z.current_acceptor_tn, 0)
ORDER BY z.id, z.accept_order, z.chat_time_d