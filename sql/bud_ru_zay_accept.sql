/* Formatted on 12.01.2018 13:13:01 (QP5 v5.252.13127.32867) */
  SELECT bud_ru_zay.id,
         TO_CHAR (bud_ru_zay.created, 'dd.mm.yyyy hh24:mi:ss') created,
         bud_ru_zay.created created_dt,
         TO_CHAR (bud_ru_zay.dt_start, 'dd.mm.yyyy') dt_start,
         TO_CHAR (bud_ru_zay.dt_end, 'dd.mm.yyyy') dt_end,
         u.phone,
         u.e_mail,
         u.skype,
         bud_ru_zay.rm_fio,
         bud_ru_zay.rm_tn,
         bud_ru_zay.tn creator_tn,
         fn_getname (bud_ru_zay.tn) creator,
         fn_getname (bud_ru_zay.recipient) recipient,
         get_bud_ru_zay_cur_status (bud_ru_zay.id) current_status,
         get_bud_ru_zay_cur_acceptor_tn (bud_ru_zay.id) current_acceptor_tn,
         DECODE (get_bud_ru_zay_cur_acceptor_tn (bud_ru_zay.id), :tn, 1, 0)
            allow_status_change,
         fn_getname (
            (SELECT tn
               FROM bud_ru_zay_accept
              WHERE     z_id = bud_ru_zay.id
                    AND accept_order =
                           (SELECT MIN (accept_order)
                              FROM bud_ru_zay_accept
                             WHERE z_id = bud_ru_zay.id AND accepted = 0)))
            current_acceptor_name,
         bud_ru_zay_accept.tn acceptor_tn,
         fn_getname (bud_ru_zay_accept.tn) acceptor_name,
         bud_ru_zay_accept.accepted,
         bud_ru_zay_accept.failure,
         bud_ru_zay_accept.accept_order,
         bud_ru_zayat.name accepted_name,
         DECODE (bud_ru_zay_accept.accepted,
                 0, NULL,
                 TO_CHAR (bud_ru_zay_accept.lu, 'dd.mm.yyyy hh24:mi:ss'))
            accepted_date,
         DECODE ( (SELECT COUNT (*)
                     FROM bud_ru_zay_accept
                    WHERE z_id = bud_ru_zay.id AND accepted = 2),
                 0, 0,
                 1)
            deleted,
         (SELECT id
            FROM bud_ru_zay_accept
           WHERE     z_id = bud_ru_zay.id
                 AND accept_order =
                        (SELECT MIN (accept_order)
                           FROM bud_ru_zay_accept
                          WHERE z_id = bud_ru_zay.id AND accepted = 0))
            current_accept_id,
         (SELECT accept_order
            FROM bud_ru_zay_accept
           WHERE     z_id = bud_ru_zay.id
                 AND accept_order =
                        (SELECT MIN (accept_order)
                           FROM bud_ru_zay_accept
                          WHERE z_id = bud_ru_zay.id AND accepted = 0))
            current_accept_order,
         (SELECT id
            FROM bud_ru_zay_accept
           WHERE z_id = bud_ru_zay.id AND tn = :tn)
            my_bud_ru_zay_accept,
         (SELECT accept_order
            FROM bud_ru_zay_accept
           WHERE z_id = bud_ru_zay.id AND tn = :tn)
            my_accept_order,
         st.name st_name,
         kat.name kat_name,
         fn_getname (a.tn) chater,
         a.text,
         a.lu chat_time_d,
         TO_CHAR (a.lu, 'dd.mm.yyyy hh24:mi:ss') chat_time,
         a.id chat_id,
         /*(SELECT DECODE (COUNT (tn), 0, 0, 1) c
            FROM bud_ru_zay_accept
           WHERE     z_id = bud_ru_zay.id
                 AND accept_order >=
                        ( (SELECT accept_order
                             FROM bud_ru_zay_accept
                            WHERE     z_id = bud_ru_zay.id
                                  AND tn =
                                         (SELECT tn
                                            FROM bud_ru_zay_accept
                                           WHERE     z_id =
                                                        bud_ru_zay.id
                                                 AND accept_order =
                                                        (SELECT MIN (
                                                                   accept_order)
                                                           FROM bud_ru_zay_accept
                                                          WHERE     z_id =
                                                                       bud_ru_zay.id
                                                                AND accepted =
                                                                       0))))
                 AND tn = :tn)
            allow_text,*/
         u.pos_name creator_pos_name,
         u1.pos_name acceptor_pos_name,
         u2.pos_name recipient_pos_name,
         u.department_name creator_department_name,
         u1.department_name acceptor_department_name,
         u2.department_name recipient_department_name,
         u.region_name,
         bud_ru_zay.fil,
         f.name fil_name,
         fu.name funds_name,
         n.net_name,
         pt.pay_type payment_type_name,
         ss.cost_item statya_name,
         bud_ru_zay.distr_compensation,
         bud_ru_zay_executors.tn executor_tn,
         fn_getname (bud_ru_zay_executors.tn) executor_name,
         bud_ru_zay_executors.execute_order,
         bud_ru_zay_executors.pos_name executor_pos_name,
         bud_ru_zay_executors.department_name executor_department_name
    FROM bud_ru_zay,
         bud_ru_zay_accept,
         (SELECT sze.*, szu.pos_name, szu.department_name
            FROM bud_ru_zay_executors sze, user_list szu
           WHERE sze.tn = szu.tn) bud_ru_zay_executors,
         accept_types bud_ru_zayat,
         BUD_RU_st_ras st,
         BUD_RU_st_ras kat,
         user_list u,
         user_list u1,
         user_list u2,
         bud_ru_zay_chat a,
         bud_fil f,
         bud_funds fu,
         nets n,
         payment_type pt,
         statya ss
   WHERE     (SELECT NVL (tu, 0)
                FROM bud_ru_st_ras
               WHERE id = bud_ru_zay.kat) = :tu
         AND bud_ru_zay.id_net = n.id_net(+)
         AND bud_ru_zay.payment_type = pt.id(+)
         AND bud_ru_zay.statya = ss.id(+)
         AND bud_ru_zay.fil = f.id(+)
         AND bud_ru_zay.funds = fu.id(+)
         AND bud_ru_zay.tn = u.tn
         AND bud_ru_zay_accept.tn = u1.tn
         AND bud_ru_zay.recipient = u2.tn
         AND bud_ru_zay.id = bud_ru_zay_accept.z_id(+)
         AND bud_ru_zay.id = bud_ru_zay_executors.z_id(+)
         AND bud_ru_zay_accept.accepted = bud_ru_zayat.id(+)
         AND a.z_id(+) = bud_ru_zay.id
         AND BUD_RU_ZAY.st = st.id(+)
         AND BUD_RU_ZAY.kat = kat.id(+)
         AND (   (SELECT tn
                    FROM bud_ru_zay_accept
                   WHERE     z_id = bud_ru_zay.id
                         AND accept_order =
                                (SELECT MIN (accept_order)
                                   FROM bud_ru_zay_accept
                                  WHERE z_id = bud_ru_zay.id AND accepted = 0)) =
                    :tn
              OR bud_ru_zay.tn = :tn
              OR ( (SELECT accept_order
                      FROM bud_ru_zay_accept
                     WHERE     z_id = bud_ru_zay.id
                           AND accept_order =
                                  (SELECT MIN (accept_order)
                                     FROM bud_ru_zay_accept
                                    WHERE z_id = bud_ru_zay.id AND accepted = 0)) >=
                     (SELECT accept_order
                        FROM bud_ru_zay_accept
                       WHERE z_id = bud_ru_zay.id AND tn = :tn)))
         AND DECODE ( (SELECT COUNT (*)
                         FROM bud_ru_zay_accept
                        WHERE z_id = bud_ru_zay.id AND accepted = 2),
                     0, 0,
                     1) = 0
         AND get_bud_ru_zay_cur_status (bud_ru_zay.id) <> 1
         AND bud_ru_zay.valid_no = 0
         AND DECODE ( :st, 0, 0, :st) = DECODE ( :st, 0, 0, bud_ru_zay.st)
         AND DECODE ( :wait4myaccept, 0, :tn, 0) =
                DECODE ( :wait4myaccept,
                        0, get_bud_ru_zay_cur_acceptor_tn (bud_ru_zay.id),
                        0)
ORDER BY id, accept_order, chat_time_d