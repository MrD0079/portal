/* Formatted on 17/06/2015 12:50:58 (QP5 v5.227.12220.39724) */
SELECT COUNT (*) exist,
       NVL (
          AVG (
             DECODE (
                slaves1 + slaves2 + slaves3 + is_do + is_traid + is_traid_kk,
                0, 0,
                1)),
          0)
          visible
  FROM (SELECT bud_ru_zay.id,
               TO_CHAR (bud_ru_zay.created, 'dd.mm.yyyy hh24:mi:ss') created,
               TO_CHAR (bud_ru_zay.dt_start, 'dd.mm.yyyy') dt_start,
               TO_CHAR (bud_ru_zay.dt_end, 'dd.mm.yyyy') dt_end,
               TO_CHAR (bud_ru_zay.report_data, 'dd.mm.yyyy') report_data,
               TO_CHAR (bud_ru_zay.report_data_lu, 'dd.mm.yyyy hh24:mi:ss')
                  report_data_lu,
               (SELECT fio
                  FROM user_list
                 WHERE tn = bud_ru_zay.report_data_tn)
                  report_data_fio,
               bud_ru_zay.report_data_text,
               u.phone,
               u.e_mail,
               u.skype,
               bud_ru_zay.rm_fio,
               bud_ru_zay.rm_tn,
               bud_ru_zay.created created_dt,
               bud_ru_zay.valid_no,
               bud_ru_zay.valid_tn,
               fn_getname (bud_ru_zay.valid_tn) valid_fio,
               TO_CHAR (bud_ru_zay.valid_lu, 'dd.mm.yyyy hh24:mi:ss')
                  valid_lu,
               bud_ru_zay.valid_text,
               fn_getname (bud_ru_zay.tn) creator,
               bud_ru_zay.tn creator_tn,
               bud_ru_zay.recipient recipient_tn,
               fn_getname (bud_ru_zay.recipient) recipient,
               bud_ru_zay_accept.tn acceptor_tn,
               fn_getname (bud_ru_zay_accept.tn) acceptor_name,
               bud_ru_zay_accept.accepted,
               bud_ru_zay_accept.failure,
               bud_ru_zay_accept.accept_order,
               bud_ru_zayat.name accepted_name,
               DECODE (
                  bud_ru_zay_accept.accepted,
                  0, NULL,
                  TO_CHAR (bud_ru_zay_accept.lu, 'dd.mm.yyyy hh24:mi:ss'))
                  accepted_date,
               DECODE ( (SELECT COUNT (*)
                           FROM bud_ru_zay_accept
                          WHERE z_id = bud_ru_zay.id AND accepted = 2),
                       0, 0,
                       1)
                  deleted,
               (SELECT accepted
                  FROM bud_ru_zay_accept
                 WHERE     z_id = bud_ru_zay.id
                       AND accept_order =
                              DECODE (
                                 NVL (
                                    (SELECT MAX (accept_order)
                                       FROM bud_ru_zay_accept
                                      WHERE     z_id = bud_ru_zay.id
                                            AND accepted = 2),
                                    0),
                                 0, (SELECT MAX (accept_order)
                                       FROM bud_ru_zay_accept
                                      WHERE z_id = bud_ru_zay.id),
                                 (SELECT MAX (accept_order)
                                    FROM bud_ru_zay_accept
                                   WHERE     z_id = bud_ru_zay.id
                                         AND accepted = 2)))
                  current_accepted_id,
               (SELECT lu
                  FROM bud_ru_zay_accept
                 WHERE     z_id = bud_ru_zay.id
                       AND accept_order =
                              DECODE (
                                 NVL (
                                    (SELECT MAX (accept_order)
                                       FROM bud_ru_zay_accept
                                      WHERE     z_id = bud_ru_zay.id
                                            AND accepted = 2),
                                    0),
                                 0, (SELECT MAX (accept_order)
                                       FROM bud_ru_zay_accept
                                      WHERE z_id = bud_ru_zay.id),
                                 (SELECT MAX (accept_order)
                                    FROM bud_ru_zay_accept
                                   WHERE     z_id = bud_ru_zay.id
                                         AND accepted = 2)))
                  current_accepted_date,
               (SELECT COUNT (tn)
                  FROM bud_ru_zay_accept
                 WHERE z_id = bud_ru_zay.id AND tn = :tn)
                  i_am_is_acceptor,
               (SELECT COUNT (*)
                  FROM (SELECT DISTINCT slave tn
                          FROM full
                         WHERE master = :tn)
                 WHERE tn = bud_ru_zay.tn)
                  slaves1,
               (SELECT COUNT (*)
                  FROM (SELECT DISTINCT slave tn
                          FROM full
                         WHERE master = :tn)
                 WHERE tn IN (SELECT tn
                                FROM bud_ru_zay_accept
                               WHERE z_id = bud_ru_zay.id))
                  slaves2,
               (SELECT COUNT (*)
                  FROM assist
                 WHERE     child = :tn
                       AND parent IN (SELECT tn
                                        FROM bud_ru_zay_accept
                                       WHERE z_id = bud_ru_zay.id)
                       AND dpt_id = (SELECT dpt_id
                                       FROM user_list
                                      WHERE tn = bud_ru_zay.tn))
                  slaves3,
               (SELECT COUNT (*)
                  FROM full
                 WHERE slave = bud_ru_zay.tn)
                  slaves5,
               BUD_RU_ZAY.st st_id,
               BUD_RU_ZAY.kat kat_id,
               st.name st_name,
               kat.name kat_name,
               fn_getname (a.tn) chater,
               a.text,
               a.lu chat_time_d,
               TO_CHAR (a.lu, 'dd.mm.yyyy hh24:mi:ss') chat_time,
               a.id chat_id,
               DECODE ( (SELECT COUNT (*)
                           FROM bud_ru_zay_accept
                          WHERE z_id = bud_ru_zay.id AND accepted <> 0),
                       0, 1,
                       0)
                  not_seen,
               (SELECT NVL (is_do, 0)
                  FROM user_list
                 WHERE tn = :tn)
                  is_do,
               (SELECT NVL (is_traid, 0)
                  FROM user_list
                 WHERE tn = :tn)
                  is_traid,
               (SELECT NVL (is_traid_kk, 0)
                  FROM user_list
                 WHERE tn = :tn)
                  is_traid_kk,
               u.pos_id,
               u.pos_name creator_pos_name,
               u1.pos_name acceptor_pos_name,
               u2.pos_name recipient_pos_name,
               u.department_name creator_department_name,
               u1.department_name acceptor_department_name,
               u2.department_name recipient_department_name,
               u.region_name,
               bud_ru_zay.fil,
               bud_ru_zay.funds,
               f.name fil_name,
               fu.name funds_name,
               n.net_name,
               bud_ru_zay.report_short,
               pt.pay_type payment_type_name,
               ss.cost_item statya_name,bud_ru_zay.distr_compensation
          FROM bud_ru_zay,
               bud_ru_zay_accept,
               accept_types bud_ru_zayat,
               user_list u,
               user_list u1,
               user_list u2,
               BUD_RU_st_ras st,
               BUD_RU_st_ras kat,
               bud_ru_zay_chat a,
               bud_fil f,
               bud_funds fu,
               nets n,
               payment_type pt,
               statya ss
         WHERE     bud_ru_zay.id_net = n.id_net(+)
               AND bud_ru_zay.payment_type = pt.id(+)
               AND bud_ru_zay.statya = ss.id(+)
               AND bud_ru_zay.fil = f.id
               AND bud_ru_zay.funds = fu.id
               AND bud_ru_zay.id = :z_id
               AND bud_ru_zay.tn = u.tn
               AND bud_ru_zay_accept.tn = u1.tn
               AND bud_ru_zay.recipient = u2.tn
               AND bud_ru_zay.id = bud_ru_zay_accept.z_id(+)
               AND bud_ru_zay_accept.accepted = bud_ru_zayat.id(+)
               AND a.z_id(+) = bud_ru_zay.id
               AND BUD_RU_ZAY.st = st.id(+)
               AND BUD_RU_ZAY.kat = kat.id(+)) z