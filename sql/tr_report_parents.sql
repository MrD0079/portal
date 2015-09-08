/* Formatted on 24.09.2013 14:31:52 (QP5 v5.227.12220.39724) */
  SELECT u1.fio p_fio,
         u1.e_mail p_mail,
         u.fio c_fio,
         u.e_mail c_mail,
         b.manual,
         b.os,
         u.dpt_id c_dpt_id,
         u.pos_name c_pos_name
    FROM tr_order_body b,
         user_list u,
         user_list u1,
         parents p
   WHERE     b.head = :id
         AND u.tn = b.tn
         AND b.tn = p.tn
         AND u1.tn = p.parent
         AND b.manual >= 0
         AND b.completed = 1
         AND b.test = 0
ORDER BY p_fio, c_fio