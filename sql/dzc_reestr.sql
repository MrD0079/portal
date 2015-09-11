/* Formatted on 11/09/2015 16:00:03 (QP5 v5.227.12220.39724) */
  SELECT z.*, NVL (current_accepted_id, 0) current_status
    FROM (SELECT dzc.id,
                 TO_CHAR (dzc.created, 'dd.mm.yyyy hh24:mi:ss') created,
                 dzc.created created_dt,
                 dzc.comm,
                 rcy.currencyname,
                 rcs.customername,
                 rds.departmentname,
                 rps.statname,
                 rss.producttype,
                 dzc.summa,
dzc.num1s,
                 c.mt || ' ' || c.y dt,
                 dzc.valid_no,
                 dzc.valid_tn,
                 fn_getname (dzc.valid_tn) valid_fio,
                 TO_CHAR (dzc.valid_lu, 'dd.mm.yyyy hh24:mi:ss') valid_lu,
                 dzc.valid_text,
                 fn_getname (dzc.tn) creator,
                 dzc.tn creator_tn,
                 dzc.recipient recipient_tn,
                 fn_getname (dzc.recipient) recipient,
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
                 (SELECT accepted
                    FROM dzc_accept
                   WHERE     dzc_id = dzc.id
                         AND accept_order =
                                DECODE (
                                   NVL (
                                      (SELECT MAX (accept_order)
                                         FROM dzc_accept
                                        WHERE dzc_id = dzc.id AND accepted = 2),
                                      0),
                                   0, (SELECT MAX (accept_order)
                                         FROM dzc_accept
                                        WHERE dzc_id = dzc.id),
                                   (SELECT MAX (accept_order)
                                      FROM dzc_accept
                                     WHERE dzc_id = dzc.id AND accepted = 2)))
                    current_accepted_id,
                 (SELECT lu
                    FROM dzc_accept
                   WHERE     dzc_id = dzc.id
                         AND accept_order =
                                DECODE (
                                   NVL (
                                      (SELECT MAX (accept_order)
                                         FROM dzc_accept
                                        WHERE dzc_id = dzc.id AND accepted = 2),
                                      0),
                                   0, (SELECT MAX (accept_order)
                                         FROM dzc_accept
                                        WHERE dzc_id = dzc.id),
                                   (SELECT MAX (accept_order)
                                      FROM dzc_accept
                                     WHERE dzc_id = dzc.id AND accepted = 2)))
                    current_accepted_date,
                 (SELECT COUNT (tn)
                    FROM dzc_accept
                   WHERE dzc_id = dzc.id AND tn = :tn)
                    i_am_is_acceptor,
                 (SELECT COUNT (*)
                    FROM (SELECT DISTINCT slave tn
                            FROM full
                           WHERE master = :tn)
                   WHERE tn = dzc.tn)
                    slaves1,
                 (SELECT COUNT (*)
                    FROM (SELECT DISTINCT slave tn
                            FROM full
                           WHERE master = :tn)
                   WHERE tn IN (SELECT tn
                                  FROM dzc_accept
                                 WHERE dzc_id = dzc.id))
                    slaves2,
                 (SELECT COUNT (*)
                    FROM assist
                   WHERE     child = :tn
                         AND parent IN (SELECT tn
                                          FROM dzc_accept
                                         WHERE dzc_id = dzc.id)
                         AND dpt_id = (SELECT dpt_id
                                         FROM user_list
                                        WHERE tn = dzc.tn))
                    slaves3,
                 fn_getname (a.tn) chater,
                 a.text,
                 a.lu chat_time_d,
                 TO_CHAR (a.lu, 'dd.mm.yyyy hh24:mi:ss') chat_time,
                 a.id chat_id,
                 DECODE ( (SELECT COUNT (*)
                             FROM dzc_accept
                            WHERE dzc_id = dzc.id AND accepted <> 0),
                         0, 1,
                         0)
                    not_seen,
                 (SELECT NVL (is_do, 0)
                    FROM user_list
                   WHERE tn = :tn)
                    is_do,
                 u.pos_id,
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
                 AND u.dpt_id = DECODE (:country,
                                        '0', u.dpt_id,
                                        (SELECT dpt_id
                                           FROM departments
                                          WHERE cnt_kod = :country))
                 AND dzc.id = dzc_accept.dzc_id(+)
                 AND a.dzc_id(+) = dzc.id
                 AND dzc.id = f.dzc_id(+)
                 AND TRUNC (
                        DECODE (
                           :orderby,
                           1, dzc.created,
                           2, DECODE (
                                 (SELECT accepted
                                    FROM dzc_accept
                                   WHERE     dzc_id = dzc.id
                                         AND accept_order =
                                                DECODE (
                                                   NVL (
                                                      (SELECT accept_order
                                                         FROM dzc_accept
                                                        WHERE     dzc_id =
                                                                     dzc.id
                                                              AND accepted = 2),
                                                      0),
                                                   0, (SELECT MAX (
                                                                 accept_order)
                                                         FROM dzc_accept
                                                        WHERE dzc_id = dzc.id),
                                                   (SELECT accept_order
                                                      FROM dzc_accept
                                                     WHERE     dzc_id = dzc.id
                                                           AND accepted = 2))),
                                 0, NULL,
                                 (SELECT lu
                                    FROM dzc_accept
                                   WHERE     dzc_id = dzc.id
                                         AND accept_order =
                                                DECODE (
                                                   NVL (
                                                      (SELECT accept_order
                                                         FROM dzc_accept
                                                        WHERE     dzc_id =
                                                                     dzc.id
                                                              AND accepted = 2),
                                                      0),
                                                   0, (SELECT MAX (
                                                                 accept_order)
                                                         FROM dzc_accept
                                                        WHERE dzc_id = dzc.id),
                                                   (SELECT accept_order
                                                      FROM dzc_accept
                                                     WHERE     dzc_id = dzc.id
                                                           AND accepted = 2)))))) BETWEEN TO_DATE (
                                                                                             :dates_list1,
                                                                                             'dd.mm.yyyy')
                                                                                      AND TO_DATE (
                                                                                             :dates_list2,
                                                                                             'dd.mm.yyyy')
                 AND DECODE (:dzc_id, 0, dzc.id, :dzc_id) = dzc.id
                 AND dzc.CURRENCYCODE = rcy.CURRENCYCODE(+)
                 AND dzc.CUSTOMERID = rcs.CUSTOMERID(+)
                 AND dzc.DEPARTMENTID = rds.DEPARTMENTID(+)
                 AND dzc.STATID = rps.STATID(+)
                 AND dzc.H_PRODUCTTYPE = rss.H_PRODUCTTYPE(+)
                 AND dzc.dt = c.data(+)) z
   WHERE     DECODE (:status,  0, 0,  1, 1,  2, 0,  3, 0,  4, 0) =
                DECODE (:status,
                        0, 0,
                        1, current_accepted_id,
                        2, NVL (current_accepted_id, 0),
                        3, 0,
                        4, 0)
         AND DECODE (:status, 3, 1, 0) = DECODE (:status, 3, deleted, 0)
         AND DECODE (:status, 1, 0, 0) = DECODE (:status, 1, valid_no, 0)
         AND DECODE (:status, 4, 1, 0) = DECODE (:status, 4, valid_no, 0)
         AND DECODE (:who,  0, 1,  1, :tn,  2, 1) =
                DECODE (
                   :who,
                   0, DECODE (slaves1 + slaves2 + slaves3 + is_do, 0, 0, 1),
                   1, creator_tn,
                   2, DECODE (i_am_is_acceptor, 0, 0, 1))
         AND DECODE (:creator, 0, 0, :creator) =
                DECODE (:creator, 0, 0, creator_tn)
ORDER BY DECODE (:orderby,  1, created_dt,  2, current_accepted_date),
         id,
         accept_order,
         chat_time_d