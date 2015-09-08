/* Formatted on 19.06.2014 9:34:41 (QP5 v5.227.12220.39724) */
  SELECT u1.fio tr_fio,
         u1.e_mail tr_mail,
         u.fio c_fio,
         u.e_mail c_mail,
         b.manual,
         u.dpt_id c_dpt_id,
         u.pos_name c_pos_name
    FROM dc_order_body b, user_list u, user_list u1
   WHERE     b.head = :id
         AND u.tn = b.tn
         AND u.dpt_id = u1.dpt_id
         AND b.manual >= 0
         AND u1.is_coach = 1
         AND u1.datauvol IS NULL
ORDER BY tr_fio, c_fio