/* Formatted on 03/02/2016 18:32:12 (QP5 v5.252.13127.32867) */
  SELECT z.*,
         NVL (current_accepted_id, 0) current_status,
         DECODE (current_acceptor_tn, :tn, 1, 0) allow_status_change
    FROM (SELECT z.id,
                 TO_CHAR (z.created, 'dd.mm.yyyy hh24:mi:ss') created,
                 TO_CHAR (z.dt_start, 'dd.mm.yyyy') dt_start,
                 TO_CHAR (z.dt_end, 'dd.mm.yyyy') dt_end,
                 TO_CHAR (z.report_data, 'dd.mm.yyyy') report_data,
                 CASE WHEN TRUNC (SYSDATE) <= TRUNC (z.report_data) THEN 1 END
                    srok_ok,
                 TO_CHAR (z.report_data_lu, 'dd.mm.yyyy hh24:mi:ss')
                    report_data_lu,
                 z.report_done,
                 TO_CHAR (z.report_done_lu, 'dd.mm.yyyy hh24:mi:ss')
                    report_done_lu,
                 (SELECT fio
                    FROM user_list
                   WHERE tn = z.report_data_tn)
                    report_data_fio,
                 z.report_data_text,
                 z.sup_doc,
                 u.phone,
                 u.e_mail,
                 u.skype,
                 z.rm_fio,
                 z.rm_tn,
                 z.created created_dt,
                 z.valid_no,
                 z.valid_tn,
                 fn_getname (z.valid_tn) valid_fio,
                 TO_CHAR (z.valid_lu, 'dd.mm.yyyy hh24:mi:ss') valid_lu,
                 z.valid_text,
                 fn_getname (z.tn) creator,
                 z.tn creator_tn,
                 z.recipient recipient_tn,
                 fn_getname (z.recipient) recipient,
                 za.tn acceptor_tn,
                 fn_getname (za.tn) acceptor_name,
                 za.rep_accepted accepted,
                 za.rep_failure failure,
                 za.accept_order,
                 zat.name accepted_name,
                 DECODE (za.rep_accepted,
                         0, NULL,
                         TO_CHAR (za.rep_lu, 'dd.mm.yyyy hh24:mi:ss'))
                    accepted_date,
                 DECODE ( (SELECT COUNT (*)
                             FROM bud_ru_zay_accept
                            WHERE z_id = z.id AND rep_accepted = 2 AND INN_not_ReportMA (tn) = 0),
                         0, 0,
                         1)
                    deleted,
                 (SELECT accepted
                    FROM bud_ru_zay_accept
                   WHERE     z_id = z.id
                         AND accept_order =
                                DECODE (
                                   NVL ( (SELECT MAX (accept_order)
                                            FROM bud_ru_zay_accept
                                           WHERE z_id = z.id AND accepted = 2),
                                        0),
                                   0, (SELECT MAX (accept_order)
                                         FROM bud_ru_zay_accept
                                        WHERE z_id = z.id),
                                   (SELECT MAX (accept_order)
                                      FROM bud_ru_zay_accept
                                     WHERE z_id = z.id AND accepted = 2)))
                    z_current_accepted_id,
                 (SELECT rep_accepted
                    FROM bud_ru_zay_accept
                   WHERE     z_id = z.id AND INN_not_ReportMA (tn) = 0
                         AND accept_order =
                                DECODE (
                                   NVL (
                                      (SELECT MAX (accept_order)
                                         FROM bud_ru_zay_accept
                                        WHERE z_id = z.id AND rep_accepted = 2 AND INN_not_ReportMA (tn) = 0),
                                      0),
                                   0, (SELECT MAX (accept_order)
                                         FROM bud_ru_zay_accept
                                        WHERE     z_id = z.id
                                              AND rep_accepted IS NOT NULL AND INN_not_ReportMA (tn) = 0),
                                   (SELECT MAX (accept_order)
                                      FROM bud_ru_zay_accept
                                     WHERE z_id = z.id AND rep_accepted = 2 AND INN_not_ReportMA (tn) = 0)))
                    current_accepted_id,
                 (SELECT tn
                    FROM bud_ru_zay_accept
                   WHERE     z_id = z.id
                         AND accept_order =
                                (SELECT MIN (accept_order)
                                   FROM bud_ru_zay_accept
                                  WHERE z_id = z.id AND rep_accepted = 0 AND INN_not_ReportMA (tn) = 0))
                    current_acceptor_tn,
                 (SELECT id
                    FROM bud_ru_zay_accept
                   WHERE     z_id = z.id
                         AND accept_order =
                                (SELECT MIN (accept_order)
                                   FROM bud_ru_zay_accept
                                  WHERE z_id = z.id AND rep_accepted = 0 AND INN_not_ReportMA (tn) = 0))
                    current_accept_id,
                 (SELECT lu
                    FROM bud_ru_zay_accept
                   WHERE     z_id = z.id
                         AND accept_order =
                                DECODE (
                                   NVL (
                                      (SELECT MAX (accept_order)
                                         FROM bud_ru_zay_accept
                                        WHERE z_id = z.id AND rep_accepted = 2 AND INN_not_ReportMA (tn) = 0),
                                      0),
                                   0, (SELECT MAX (accept_order)
                                         FROM bud_ru_zay_accept
                                        WHERE     z_id = z.id
                                              AND rep_accepted IS NOT NULL AND INN_not_ReportMA (tn) = 0),
                                   (SELECT MAX (accept_order)
                                      FROM bud_ru_zay_accept
                                     WHERE z_id = z.id AND rep_accepted = 2 AND INN_not_ReportMA (tn) = 0)))
                    current_accepted_date,
                 (SELECT COUNT (tn)
                    FROM bud_ru_zay_accept
                   WHERE z_id = z.id AND tn = :tn)
                    i_am_is_acceptor,
                 (SELECT COUNT (*)
                    FROM (SELECT DISTINCT slave tn
                            FROM full
                           WHERE master = :tn)
                   WHERE tn = z.tn)
                    slaves1,
                 (SELECT COUNT (*)
                    FROM (SELECT DISTINCT slave tn
                            FROM full
                           WHERE master = :tn)
                   WHERE tn IN (SELECT tn
                                  FROM bud_ru_zay_accept
                                 WHERE z_id = z.id))
                    slaves2,
                 (SELECT COUNT (*)
                    FROM assist
                   WHERE     child = :tn
                         AND parent IN (SELECT tn
                                          FROM bud_ru_zay_accept
                                         WHERE z_id = z.id)
                         AND dpt_id = (SELECT dpt_id
                                         FROM user_list
                                        WHERE tn = z.tn))
                    slaves3,
                 (SELECT COUNT (*)
                    FROM bud_ru_zay_executors
                   WHERE tn = :tn AND z_id = z.id)
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
                         AND slave = z.tn)
                    slaves5,
                 z.st st_id,
                 z.kat kat_id,
                 st.name st_name,
                 kat.name kat_name,
                 fn_getname (a.tn) chater,
                 a.tn chater_tn,
                 a.text,
                 a.lu chat_time_d,
                 TO_CHAR (a.lu, 'dd.mm.yyyy hh24:mi:ss') chat_time,
                 a.id chat_id,
                 fn_getname (ac.tn) zchater,
                 ac.tn zchater_tn,
                 ac.text ztext,
                 ac.lu zchat_time_d,
                 TO_CHAR (ac.lu, 'dd.mm.yyyy hh24:mi:ss') zchat_time,
                 ac.id zchat_id,
                 DECODE ( (SELECT COUNT (*)
                             FROM bud_ru_zay_accept
                            WHERE z_id = z.id AND rep_accepted <> 0 AND INN_not_ReportMA (tn) = 0),
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
                 z.fil,
                 z.funds,
                 z.id_net,
                 f.name fil_name,
                 fu.name funds_name,
                 n.net_name,
                 z.report_short,
                 pt.pay_type payment_type_name,
                 ss.cost_item statya_name,
                 z.distr_compensation,
                 z.report_zero_cost,
                z.report_fakt_equal_plan,
                 bud_ru_zay_executors.tn executor_tn,
                 fn_getname (bud_ru_zay_executors.tn) executor_name,
                 bud_ru_zay_executors.execute_order,
                 bud_ru_zay_executors.pos_name executor_pos_name,
                 bud_ru_zay_executors.department_name executor_department_name,TO_CHAR (z.cost_assign_month, 'dd.mm.yyyy') cost_assign_month
            FROM bud_ru_zay z,
                 bud_ru_zay_accept za,
                 (SELECT sze.*, szu.pos_name, szu.department_name
                    FROM bud_ru_zay_executors sze, user_list szu
                   WHERE sze.tn = szu.tn) bud_ru_zay_executors,
                 accept_types zat,
                 user_list u,
                 user_list u1,
                 user_list u2,
                 BUD_RU_st_ras st,
                 BUD_RU_st_ras kat,
                 bud_ru_zay_rep_chat a,
                 bud_ru_zay_chat ac,
                 bud_fil f,
                 bud_funds fu,
                 nets n,
                 payment_type pt,
                 statya ss
           WHERE     (SELECT NVL (tu, 0)
                        FROM bud_ru_st_ras
                       WHERE id = z.kat) = :tu
                 AND z.id_net = n.id_net(+)
                 /*dyn_flt*/
                 AND z.payment_type = pt.id(+)
                 AND z.statya = ss.id(+)
                 AND z.fil = f.id(+)
                 AND z.funds = fu.id(+)
                 AND z.tn = u.tn
                 AND (   :exp_list_without_ts = 0
                      OR u.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_without_ts))
                 AND za.tn = u1.tn
                 AND z.recipient = u2.tn
                 AND u.dpt_id = DECODE ( :country,
                                        '0', u.dpt_id,
                                        (SELECT dpt_id
                                           FROM departments
                                          WHERE cnt_kod = :country))
                 AND z.id = za.z_id(+)
                 AND z.id = bud_ru_zay_executors.z_id(+)
                 AND za.rep_accepted = zat.id(+)
                 AND za.rep_accepted IS NOT NULL AND INN_not_ReportMA (za.tn) = 0
                 AND a.z_id(+) = z.id
                 AND ac.z_id(+) = z.id
                 AND z.st = st.id(+)
                 AND z.kat = kat.id(+)
                 AND CASE
                        WHEN :date_between_brzr = 'dt12' THEN TRUNC (z.created)
                        WHEN :date_between_brzr = 'dt34' THEN z.dt_start
                     END BETWEEN TO_DATE ( :dates_list1, 'dd.mm.yyyy')
                             AND TO_DATE ( :dates_list2, 'dd.mm.yyyy')
                 AND DECODE ( :z_id, 0, z.id, :z_id) = z.id) z
   WHERE     1 = z_current_accepted_id
         AND report_data IS NOT NULL
         AND :srok_ok = DECODE ( :srok_ok, 0, 0, DECODE (srok_ok, NULL, 2, 1))
         AND :report_done_flt =
                DECODE ( :report_done_flt,
                        0, 0,
                        DECODE (NVL (report_fakt_equal_plan, 0) + NVL (report_done, 0), 0, 2, 1))
         AND :report_zero_cost =
                DECODE ( :report_zero_cost,
                        0, 0,
                        NVL (report_zero_cost, 0))
         AND DECODE ( :status,  0, 0,  1, 1,  2, 0,  3, 0,  4, 0) =
                DECODE ( :status,
                        0, 0,
                        1, current_accepted_id,
                        2, NVL (current_accepted_id, 0),
                        3, 0,
                        4, 0)
         AND DECODE ( :status, 3, 1, 0) = DECODE ( :status, 3, deleted, 0)
         AND DECODE ( :status, 4, 1, 0) = NVL (valid_no, 0)
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
         AND DECODE ( :bud_ru_zay_pos_id, 0, 0, :bud_ru_zay_pos_id) =
                DECODE ( :bud_ru_zay_pos_id, 0, 0, pos_id)
         AND DECODE ( :region_name, '0', '0', :region_name) =
                DECODE ( :region_name, '0', '0', region_name)
         AND DECODE ( :department_name, '0', 0, 1) =
                DECODE ( :department_name, '0', 0, DECODE (slaves5, 0, 0, 1))
         AND DECODE ( :fil, 0, 0, :fil) = DECODE ( :fil, 0, 0, fil)
         AND DECODE ( :funds, 0, 0, :funds) = DECODE ( :funds, 0, 0, funds)
         AND DECODE ( :id_net, 0, 0, :id_net) = DECODE ( :id_net, 0, 0, id_net)
         AND DECODE ( :wait4myaccept, 0, :tn, 0) =
                DECODE ( :wait4myaccept, 0, z.current_acceptor_tn, 0)
         AND DECODE ( :wait4myaccept, 0, 1, 0) =
                DECODE ( :wait4myaccept, 0, nvl(report_done,0), 0)
ORDER BY created_dt,
         id,
         accept_order,
         chat_time_d,
         zchat_time_d