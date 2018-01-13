/* Formatted on 13.01.2018 18:40:49 (QP5 v5.252.13127.32867) */
  SELECT z.*, NVL (current_accepted_id, 0) current_status
    FROM (SELECT bud_ru_zay.id,
                 bud_ru_zay.report_done,
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
                 TO_CHAR (bud_ru_zay.valid_lu, 'dd.mm.yyyy hh24:mi:ss') valid_lu,
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
                 zat.name accepted_name,
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
                 get_bud_ru_zay_cur_status (bud_ru_zay.id) current_accepted_id,
                 get_bud_ru_zay_cur_status_lu (bud_ru_zay.id)
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
                    FROM bud_ru_zay_executors
                   WHERE tn = :tn AND z_id = bud_ru_zay.id)
                    slaves4,
                 (SELECT COUNT (*)
                    FROM full
                   WHERE     master IN (SELECT tn
                                          FROM user_list
                                         WHERE DECODE ( :department_name,
                                                       '0', '0',
                                                       :department_name) =
                                                  DECODE ( :department_name,
                                                          '0', '0',
                                                          department_name))
                         AND slave = bud_ru_zay.tn)
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
                 bud_ru_zay.id_net,
                 f.name fil_name,
                 fu.name funds_name,
                 n.net_name,
                 bud_ru_zay.report_short,
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
                 accept_types zat,
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
           WHERE     (SELECT NVL (tu, 0)
                        FROM bud_ru_st_ras
                       WHERE id = bud_ru_zay.kat) = :tu
                 AND bud_ru_zay.id_net = n.id_net(+)
                 /*dyn_flt*/
                 AND bud_ru_zay.payment_type = pt.id(+)
                 AND bud_ru_zay.statya = ss.id(+)
                 AND bud_ru_zay.fil = f.id(+)
                 AND bud_ru_zay.funds = fu.id(+)
                 AND bud_ru_zay.tn = u.tn
                 AND (   :exp_list_without_ts = 0
                      OR u.tn IN (SELECT slave
                                    FROM full
                                   WHERE master = :exp_list_without_ts))
                 AND bud_ru_zay_accept.tn = u1.tn
                 AND bud_ru_zay.recipient = u2.tn
                 AND u.dpt_id = DECODE ( :country,
                                        '0', u.dpt_id,
                                        (SELECT dpt_id
                                           FROM departments
                                          WHERE cnt_kod = :country))
                 AND bud_ru_zay.id = bud_ru_zay_accept.z_id(+)
                 AND bud_ru_zay.id = bud_ru_zay_executors.z_id(+)
                 AND bud_ru_zay_accept.accepted = zat.id(+)
                 AND a.z_id(+) = bud_ru_zay.id
                 AND BUD_RU_ZAY.st = st.id(+)
                 AND BUD_RU_ZAY.kat = kat.id(+)
                 AND TRUNC (
                        DECODE (
                           :orderby,
                           1, CASE
                                 WHEN :date_between_brzr = 'dt12'
                                 THEN
                                    TRUNC (bud_ru_zay.created)
                                 WHEN :date_between_brzr = 'dt34'
                                 THEN
                                    bud_ru_zay.dt_start
                              END,
                           2, DECODE (
                                 get_bud_ru_zay_cur_status (bud_ru_zay.id),
                                 0, NULL,
                                 get_bud_ru_zay_cur_status_lu (bud_ru_zay.id)))) BETWEEN TO_DATE (
                                                                                            :dates_list1,
                                                                                            'dd.mm.yyyy')
                                                                                     AND TO_DATE (
                                                                                            :dates_list2,
                                                                                            'dd.mm.yyyy')
                 AND DECODE ( :z_id, 0, bud_ru_zay.id, :z_id) = bud_ru_zay.id) z
   WHERE     DECODE ( :status,  0, 0,  1, 1,  2, 0,  3, 0,  4, 0) =
                DECODE ( :status,
                        0, 0,
                        1, current_accepted_id,
                        2, NVL (current_accepted_id, 0),
                        3, 0,
                        4, 0)
         AND DECODE ( :status, 3, 1, 0) = DECODE ( :status, 3, deleted, 0)
         AND DECODE ( :status, 1, 0, 0) = DECODE ( :status, 1, valid_no, 0)
         AND DECODE ( :status, 4, 1, 0) = DECODE ( :status, 4, valid_no, 0)
         AND DECODE ( :who,  0, 1,  1, :tn,  2, 1) =
                DECODE (
                   :who,
                   0, DECODE (
                           slaves1
                         + slaves2
                         + slaves3
                         + slaves4
                         + is_do
                         + is_traid
                         + is_traid_kk,
                         0, 0,
                         1),
                   1, creator_tn,
                   2, DECODE (i_am_is_acceptor, 0, 0, 1))
         AND DECODE ( :st, 0, 0, :st) = DECODE ( :st, 0, 0, st_id)
         AND DECODE ( :kat, 0, 0, :kat) = DECODE ( :kat, 0, 0, kat_id)
         AND DECODE ( :creator, 0, 0, :creator) =
                DECODE ( :creator, 0, 0, creator_tn)
         AND DECODE ( :r_pos_id, 0, 0, :r_pos_id) =
                DECODE ( :r_pos_id, 0, 0, pos_id)
         AND DECODE ( :region_name, '0', '0', :region_name) =
                DECODE ( :region_name, '0', '0', region_name)
         AND DECODE ( :department_name, '0', 0, 1) =
                DECODE ( :department_name, '0', 0, DECODE (slaves5, 0, 0, 1))
         AND DECODE ( :fil, 0, 0, :fil) = DECODE ( :fil, 0, 0, fil)
         AND DECODE ( :funds, 0, 0, :funds) = DECODE ( :funds, 0, 0, funds)
         AND DECODE ( :id_net, 0, 0, :id_net) = DECODE ( :id_net, 0, 0, id_net)
         AND :report_data =
                DECODE ( :report_data, 0, 0, DECODE (report_data, NULL, 2, 1))
ORDER BY DECODE ( :orderby,  1, created_dt,  2, current_accepted_date),
         id,
         accept_order,
         chat_time_d