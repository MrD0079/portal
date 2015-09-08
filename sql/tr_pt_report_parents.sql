/* Formatted on 16.09.2013 13:17:44 (QP5 v5.227.12220.39724) */
  SELECT u1.fio p_fio,
         u1.e_mail p_mail,
         u.fio c_fio,
         u.e_mail c_mail,
         b.manual,
         b.os,
         u.dpt_id c_dpt_id,
         u.pos_name c_pos_name
    FROM tr_pt_order_body b,
         user_list u,
         user_list u1,
         parents_eta p
   WHERE     b.head = :id
         AND u.h_eta = b.h_eta
         AND b.h_eta = p.h_eta
         AND u1.tn = p.chief_tn
         AND u.dpt_id = p.dpt_id
         AND u.dpt_id = u1.dpt_id
         AND b.manual >= 0
         AND b.completed = 1
         AND b.test = 0
ORDER BY p_fio, c_fio