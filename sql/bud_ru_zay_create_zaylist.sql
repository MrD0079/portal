/* Formatted on 17/06/2015 12:50:25 (QP5 v5.227.12220.39724) */
  SELECT z.*
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
                 z.st st_id,
                 z.kat kat_id,
                 st.name st_name,
                 kat.name kat_name,
                 u.pos_id,
                 u.pos_name creator_pos_name,
                 u2.pos_name recipient_pos_name,
                 u.department_name creator_department_name,
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
                 ss.cost_item statya_name
            FROM bud_ru_zay z,
                 user_list u,
                 user_list u2,
                 BUD_RU_st_ras st,
                 BUD_RU_st_ras kat,
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
                 AND z.recipient = u2.tn
                 AND NVL (z.valid_no, 0) <> 1
                 AND z.st = st.id(+)
                 AND z.kat = kat.id(+)
                 AND z.tn = :tn
                 AND z.report_data IS NOT NULL
                 AND z.report_done IS NULL) z
   WHERE z_current_accepted_id = 1 AND srok_ok IS NULL
ORDER BY created_dt, id