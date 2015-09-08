/* Formatted on 13/09/2013 14:03:02 (QP5 v5.227.12220.39724) */
  SELECT u1.fio p_fio,
         u1.e_mail p_mail,
         u1.dpt_id,
         u1.dpt_name,
         u.fio c_fio,
         u.e_mail c_mail,
         b.manual,
         b.os,
         u.dpt_id c_dpt_id,
         u.pos_name c_pos_name
    FROM tr_pt_order_body b,
         user_list u,
         user_list u1,
         parents_eta pe
   WHERE     b.head = :id
         AND u.h_eta = b.h_eta
         AND b.h_eta = pe.h_eta
         AND u1.tn = pe.chief_tn
         AND u.dpt_id = u1.dpt_id
         AND b.manual >= 0
ORDER BY p_fio, c_fio