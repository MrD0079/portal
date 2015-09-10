/* Formatted on 17/06/2015 12:56:17 (QP5 v5.227.12220.39724) */
SELECT COUNT (*) exist,
       NVL (
          AVG (
             DECODE (
                slaves1 + slaves2 + slaves3 + is_do + is_traid + is_traid_kk,
                0, 0,
                1)),
          0)
          visible
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
                          WHERE z_id = z.id AND rep_accepted = 2),
                       0, 0,
                       1)
                  deleted,
               (SELECT accepted
                  FROM bud_ru_zay_accept
                 WHERE     z_id = z.id
                       AND accept_order =
                              DECODE (
                                 NVL (
                                    (SELECT MAX (accept_order)
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
                 WHERE     z_id = z.id
                       AND accept_order =
                              DECODE (
                                 NVL (
                                    (SELECT MAX (accept_order)
                                       FROM bud_ru_zay_accept
                                      WHERE     z_id = z.id
                                            AND rep_accepted = 2),
                                    0),
                                 0, (SELECT MAX (accept_order)
                                       FROM bud_ru_zay_accept
                                      WHERE z_id = z.id),
                                 (SELECT MAX (accept_order)
                                    FROM bud_ru_zay_accept
                                   WHERE     z_id = z.id
                                         AND rep_accepted = 2)))
                  current_accepted_id,
               (SELECT tn
                  FROM bud_ru_zay_accept
                 WHERE     z_id = z.id
                       AND accept_order =
                              (SELECT MIN (accept_order)
                                 FROM bud_ru_zay_accept
                                WHERE z_id = z.id AND rep_accepted = 0))
                  current_acceptor_tn,
               (SELECT id
                  FROM bud_ru_zay_accept
                 WHERE     z_id = z.id
                       AND accept_order =
                              (SELECT MIN (accept_order)
                                 FROM bud_ru_zay_accept
                                WHERE z_id = z.id AND rep_accepted = 0))
                  current_accept_id,
               (SELECT lu
                  FROM bud_ru_zay_accept
                 WHERE     z_id = z.id
                       AND accept_order =
                              DECODE (
                                 NVL (
                                    (SELECT MAX (accept_order)
                                       FROM bud_ru_zay_accept
                                      WHERE     z_id = z.id
                                            AND rep_accepted = 2),
                                    0),
                                 0, (SELECT MAX (accept_order)
                                       FROM bud_ru_zay_accept
                                      WHERE z_id = z.id),
                                 (SELECT MAX (accept_order)
                                    FROM bud_ru_zay_accept
                                   WHERE     z_id = z.id
                                         AND rep_accepted = 2)))
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
               z.st st_id,
               z.kat kat_id,
               st.name st_name,
               kat.name kat_name,
               fn_getname (a.tn) chater,
               a.text,
               a.lu chat_time_d,
               TO_CHAR (a.lu, 'dd.mm.yyyy hh24:mi:ss') chat_time,
               a.id chat_id,
               fn_getname (ac.tn) zchater,
               ac.text ztext,
               ac.lu zchat_time_d,
               TO_CHAR (ac.lu, 'dd.mm.yyyy hh24:mi:ss') zchat_time,
               ac.id zchat_id,
               DECODE ( (SELECT COUNT (*)
                           FROM bud_ru_zay_accept
                          WHERE z_id = z.id AND rep_accepted <> 0),
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
               f.name fil_name,
               fu.name funds_name,
               n.net_name,
               z.report_short,
               pt.pay_type payment_type_name,
               ss.cost_item statya_name,z.distr_compensation
          FROM bud_ru_zay z,
               bud_ru_zay_accept za,
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
         WHERE     z.id_net = n.id_net(+)
               AND z.payment_type = pt.id(+)
               AND z.statya = ss.id(+)
               AND z.fil = f.id
               AND z.funds = fu.id
               AND z.tn = u.tn
               AND za.tn = u1.tn
               AND z.recipient = u2.tn
               AND z.id = za.z_id(+)
               AND za.rep_accepted = zat.id(+)
               AND za.rep_accepted IS NOT NULL
               AND a.z_id(+) = z.id
               AND ac.z_id(+) = z.id
               AND z.st = st.id(+)
               AND z.kat = kat.id(+)
               AND z.id = :z_id) z
 WHERE 1 = z_current_accepted_id AND report_data IS NOT NULL