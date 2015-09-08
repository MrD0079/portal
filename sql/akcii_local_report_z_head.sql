/* Formatted on 17/06/2015 12:49:11 (QP5 v5.227.12220.39724) */
SELECT bud_ru_zay.id,
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
       BUD_RU_ZAY.st st_id,
       BUD_RU_ZAY.kat kat_id,
       st.name st_name,
       kat.name kat_name,
       u.pos_id,
       u.pos_name creator_pos_name,
       u2.pos_name recipient_pos_name,
       u.department_name creator_department_name,
       u2.department_name recipient_department_name,
       u.region_name,
       bud_ru_zay.fil,
       bud_ru_zay.funds,
       f.name fil_name,
       fu.name funds_name,
       n.net_name,
       bud_ru_zay.report_short,
       pt.pay_type payment_type_name,
       ss.cost_item statya_name
  FROM bud_ru_zay,
       user_list u,
       user_list u2,
       BUD_RU_st_ras st,
       BUD_RU_st_ras kat,
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
       AND bud_ru_zay.recipient = u2.tn
       AND BUD_RU_ZAY.st = st.id(+)
       AND BUD_RU_ZAY.kat = kat.id(+)