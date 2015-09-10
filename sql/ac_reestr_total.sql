/* Formatted on 04.02.2014 8:38:58 (QP5 v5.227.12220.39724) */
  SELECT current_status,
         (SELECT name1
            FROM accept_types
           WHERE id = z.current_status)
            current_status_txt,
         COUNT (*) c
    FROM (SELECT DISTINCT
                 z.id, NVL (current_accepted_id, 0) current_status
            FROM (SELECT ac.id,
                         TO_CHAR (ac.created, 'dd.mm.yyyy hh24:mi:ss') created,
                         ac.created created_dt,
                         ac.head,
                         ac.body,
                         ac.valid_no,
                         fn_getname ( ac.tn) creator,
                         ac.tn creator_tn,
                         ac.recipient recipient_tn,
                         fn_getname ( ac.recipient) recipient,
                         ac_executors.tn executor_tn,
                         fn_getname ( ac_executors.tn) executor_name,
                         ac_accept.tn acceptor_tn,
                         fn_getname ( ac_accept.tn) acceptor_name,
                         ac_accept.accepted,
                         ac_accept.failure,
                         ac_accept.accept_order,
                         acat.name accepted_name,
                         DECODE (
                            ac_accept.accepted,
                            0, NULL,
                            TO_CHAR (ac_accept.lu, 'dd.mm.yyyy hh24:mi:ss'))
                            accepted_date,
                         DECODE ( (SELECT COUNT (*)
                                     FROM ac_accept
                                    WHERE ac_id = ac.id AND accepted = 2),
                                 0, 0,
                                 1)
                            deleted,
                         f.fn,
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
                                                WHERE ac_id = ac.id /* AND accepted <> 0*/
                                                                   ),
                                           (SELECT MAX (accept_order)
                                              FROM ac_accept
                                             WHERE     ac_id = ac.id
                                                   AND accepted = 2)))
                            current_accepted_id,
                         (SELECT lu
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
                                                WHERE ac_id = ac.id /* AND accepted <> 0*/
                                                                   ),
                                           (SELECT MAX (accept_order)
                                              FROM ac_accept
                                             WHERE     ac_id = ac.id
                                                   AND accepted = 2)))
                            current_accepted_date,
                         (SELECT COUNT (tn)
                            FROM ac_accept
                           WHERE ac_id = ac.id AND tn = :tn)
                            i_am_is_acceptor,
                         (SELECT COUNT (*)
                            FROM (SELECT DISTINCT slave tn
                                    FROM full
                                   WHERE master = :tn)
                           WHERE tn = ac.tn)
                            slaves1,
                         (SELECT COUNT (*)
                            FROM (SELECT DISTINCT slave tn
                                    FROM full
                                   WHERE master = :tn)
                           WHERE tn IN (SELECT tn
                                          FROM ac_accept
                                         WHERE ac_id = ac.id))
                            slaves2,
                         (SELECT COUNT (*)
                            FROM assist
                           WHERE     child = :tn
                                 AND parent IN (SELECT tn
                                                  FROM ac_accept
                                                 WHERE ac_id = ac.id)
                                 AND dpt_id = (SELECT dpt_id
                                                 FROM user_list
                                                WHERE tn = ac.tn))
                            slaves3,
                         (SELECT COUNT (*)
                            FROM ac_executors
                           WHERE tn = :tn AND ac_id = ac.id)
                            slaves4,
                         (SELECT COUNT (*)
                            FROM full
                           WHERE     master IN
                                        (SELECT tn
                                           FROM user_list
                                          WHERE DECODE (
                                                   :department_name,
                                                   '0', '0',
                                                   :department_name) =
                                                   DECODE (:department_name,
                                                           '0', '0',
                                                           department_name))
                                 AND slave = ac.tn)
                            slaves5,
                         (SELECT COUNT (*)
                            FROM ac_executors
                           WHERE tn = :executor AND ac_id = ac.id)
                            executors,
                         ac_executors.execute_order,
                         sc.id cat_id,
                         sc.name cat_name,
                         a.text,
                         TO_CHAR (a.lu, 'dd.mm.yyyy hh24:mi:ss') chat_time,
                         a.id chat_id,
                         DECODE (
                            (SELECT COUNT (*)
                               FROM ac_accept
                              WHERE ac_id = ac.id AND accepted <> 0),
                            0, 1,
                            0)
                            not_seen,
                         (SELECT NVL (is_do, 0)
                            FROM user_list
                           WHERE tn = :tn)
                            is_do,
                         u.pos_id,
                         u1.pos_name,
                         u.department_name,
                         u.region_name
                    FROM ac,
                         ac_accept,
                         ac_executors,
                         accept_types acat,
                         ac_files f,
                         user_list u,
                         user_list u1,
                         ac_cat sc,
                         ac_chat a
                   WHERE     ac.tn = u.tn
                         AND ac_accept.tn = u1.tn
                         AND u.dpt_id = DECODE (:country,
                                                '0', u.dpt_id,
                                                (SELECT dpt_id
                                                   FROM departments
                                                  WHERE cnt_kod = :country))
                         AND ac.id = ac_accept.ac_id(+)
                         AND ac.id = ac_executors.ac_id(+)
                         AND ac_accept.accepted = acat.id(+)
                         AND a.ac_id(+) = ac.id
                         AND ac.id = f.ac_id(+)
                         AND ac.cat = sc.id(+)
                         AND TRUNC (
                                DECODE (
                                   :orderby,
                                   1, ac.created,
                                   2, DECODE (
                                         (SELECT accepted
                                            FROM ac_accept
                                           WHERE     ac_id = ac.id
                                                 AND accept_order =
                                                        DECODE (
                                                           NVL (
                                                              (SELECT accept_order
                                                                 FROM ac_accept
                                                                WHERE     ac_id =
                                                                             ac.id
                                                                      AND accepted =
                                                                             2),
                                                              0),
                                                           0, (SELECT MAX (
                                                                         accept_order)
                                                                 FROM ac_accept
                                                                WHERE ac_id =
                                                                         ac.id /* AND accepted <> 0*/
                                                                              ),
                                                           (SELECT accept_order
                                                              FROM ac_accept
                                                             WHERE     ac_id =
                                                                          ac.id
                                                                   AND accepted =
                                                                          2))),
                                         0, NULL,
                                         (SELECT lu
                                            FROM ac_accept
                                           WHERE     ac_id = ac.id
                                                 AND accept_order =
                                                        DECODE (
                                                           NVL (
                                                              (SELECT accept_order
                                                                 FROM ac_accept
                                                                WHERE     ac_id =
                                                                             ac.id
                                                                      AND accepted =
                                                                             2),
                                                              0),
                                                           0, (SELECT MAX (
                                                                         accept_order)
                                                                 FROM ac_accept
                                                                WHERE ac_id =
                                                                         ac.id /* AND accepted <> 0*/
                                                                              ),
                                                           (SELECT accept_order
                                                              FROM ac_accept
                                                             WHERE     ac_id =
                                                                          ac.id
                                                                   AND accepted =
                                                                          2)))))) BETWEEN TO_DATE (
                                                                                                  :dates_list1,
                                                                                                  'dd.mm.yyyy')
                                                                                           AND TO_DATE (
                                                                                                  :dates_list2,
                                                                                                  'dd.mm.yyyy')) z
           WHERE     DECODE (:status,
                             0, 0,
                             1, 1,
                             2, 0,
                             3, 0,
                             4, 0) =
                        DECODE (:status,
                                0, 0,
                                1, current_accepted_id,
                                2, NVL (current_accepted_id, 0),
                                3, 0,
                                4, 0)
                 AND DECODE (:status, 3, 1, 0) =
                        DECODE (:status, 3, deleted, 0)
                 AND DECODE (:status, 1, 0, 0) =
                        DECODE (:status, 1, valid_no, 0)
                 AND DECODE (:status, 4, 1, 0) =
                        DECODE (:status, 4, valid_no, 0)
                 AND DECODE (:who,  0, 1,  1, :tn,  2, 1) =
                        DECODE (
                           :who,
                           0, DECODE (
                                 slaves1 + slaves2 + slaves3 + slaves4 + is_do,
                                 0, 0,
                                 1),
                           1, creator_tn,
                           2, DECODE (i_am_is_acceptor, 0, 0, 1))
                 AND DECODE (:ac_cat, 0, 0, :ac_cat) =
                        DECODE (:ac_cat, 0, 0, cat_id)
                 AND DECODE (:executor, 0, 0, 1) = executors
                 AND DECODE (:creator, 0, 0, :creator) =
                        DECODE (:creator, 0, 0, creator_tn)
                 AND DECODE (:ac_pos_id, 0, 0, :ac_pos_id) =
                        DECODE (:ac_pos_id, 0, 0, pos_id)
                 AND DECODE (:region_name, '0', '0', :region_name) =
                        DECODE (:region_name, '0', '0', region_name)
                 AND DECODE (:department_name, '0', 0, 1) =
                        DECODE (:department_name,
                                '0', 0,
                                DECODE (slaves5, 0, 0, 1))) z
GROUP BY current_status