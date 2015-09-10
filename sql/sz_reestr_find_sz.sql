/* Formatted on 14/10/2014 14:02:53 (QP5 v5.227.12220.39724) */
SELECT COUNT (*) exist,
       NVL (
          AVG (
             DECODE (slaves1 + slaves2 + slaves3 + slaves4 + is_do, 0, 0, 1)),
          0)
          visible
  FROM (SELECT sz.id,
               TO_CHAR (sz.created, 'dd.mm.yyyy hh24:mi:ss') created,
               sz.created created_dt,
               sz.head,
               sz.body,
               sz.valid_no,
               sz.valid_tn,
               fn_getname ( sz.valid_tn) valid_fio,
               TO_CHAR (sz.valid_lu, 'dd.mm.yyyy hh24:mi:ss') valid_lu,
               sz.valid_text,
               fn_getname ( sz.tn) creator,
               sz.tn creator_tn,
               sz.recipient recipient_tn,
               fn_getname ( sz.recipient) recipient,
               sz_executors.tn executor_tn,
               fn_getname ( sz_executors.tn) executor_name,
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
               (SELECT accepted
                  FROM sz_accept
                 WHERE     sz_id = sz.id
                       AND accept_order =
                              DECODE (
                                 NVL (
                                    (SELECT MAX (accept_order)
                                       FROM sz_accept
                                      WHERE     sz_id = sz.id
                                            AND accepted = 2),
                                    0),
                                 0, (SELECT MAX (accept_order)
                                       FROM sz_accept
                                      WHERE sz_id = sz.id),
                                 (SELECT MAX (accept_order)
                                    FROM sz_accept
                                   WHERE sz_id = sz.id AND accepted = 2)))
                  current_accepted_id,
               (SELECT lu
                  FROM sz_accept
                 WHERE     sz_id = sz.id
                       AND accept_order =
                              DECODE (
                                 NVL (
                                    (SELECT MAX (accept_order)
                                       FROM sz_accept
                                      WHERE     sz_id = sz.id
                                            AND accepted = 2),
                                    0),
                                 0, (SELECT MAX (accept_order)
                                       FROM sz_accept
                                      WHERE sz_id = sz.id),
                                 (SELECT MAX (accept_order)
                                    FROM sz_accept
                                   WHERE sz_id = sz.id AND accepted = 2)))
                  current_accepted_date,
               (SELECT COUNT (tn)
                  FROM sz_accept
                 WHERE sz_id = sz.id AND tn = :tn)
                  i_am_is_acceptor,
               (SELECT COUNT (*)
                  FROM (SELECT DISTINCT slave tn
                          FROM full
                         WHERE master = :tn)
                 WHERE tn = sz.tn)
                  slaves1,
               (SELECT COUNT (*)
                  FROM (SELECT DISTINCT slave tn
                          FROM full
                         WHERE master = :tn)
                 WHERE tn IN (SELECT tn
                                FROM sz_accept
                               WHERE sz_id = sz.id))
                  slaves2,
               (SELECT COUNT (*)
                  FROM assist
                 WHERE     child = :tn
                       AND parent IN (SELECT tn
                                        FROM sz_accept
                                       WHERE sz_id = sz.id)
                       AND dpt_id = (SELECT dpt_id
                                       FROM user_list
                                      WHERE tn = sz.tn))
                  slaves3,
               (SELECT COUNT (*)
                  FROM sz_executors
                 WHERE tn = :tn AND sz_id = sz.id)
                  slaves4,
               (SELECT COUNT (*)
                  FROM full
                 WHERE slave = sz.tn)
                  slaves5,
               sz_executors.execute_order,
               sc.id cat_id,
               sc.name cat_name,
               fn_getname ( a.tn) chater,
               a.text,
               a.lu chat_time_d,
               TO_CHAR (a.lu, 'dd.mm.yyyy hh24:mi:ss') chat_time,
               a.id chat_id,
               DECODE ( (SELECT COUNT (*)
                           FROM sz_accept
                          WHERE sz_id = sz.id AND accepted <> 0),
                       0, 1,
                       0)
                  not_seen,
               (SELECT NVL (is_do, 0)
                  FROM user_list
                 WHERE tn = :tn)
                  is_do,
               u.pos_id,
               u.pos_name creator_pos_name,
               sz_executors.pos_name executor_pos_name,
               sz_executors.department_name executor_department_name,
               u1.pos_name acceptor_pos_name,
               u2.pos_name recipient_pos_name,
               u.department_name creator_department_name,
               u1.department_name acceptor_department_name,
               u2.department_name recipient_department_name,
               u.region_name
          FROM sz,
               sz_accept,
               (SELECT sze.*, szu.pos_name, szu.department_name
                  FROM sz_executors sze, user_list szu
                 WHERE sze.tn = szu.tn) sz_executors,
               accept_types szat,
               sz_files f,
               user_list u,
               user_list u1,
               user_list u2,
               sz_cat sc,
               sz_chat a
         WHERE     sz.id = :sz_id
               AND sz.tn = u.tn
               AND sz_accept.tn = u1.tn
               AND sz.recipient = u2.tn
               AND sz.id = sz_accept.sz_id(+)
               AND sz.id = sz_executors.sz_id(+)
               AND sz_accept.accepted = szat.id(+)
               AND a.sz_id(+) = sz.id
               AND sz.id = f.sz_id(+)
               AND sz.cat = sc.id(+)) z