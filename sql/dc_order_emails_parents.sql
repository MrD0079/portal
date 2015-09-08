/* Formatted on 04.03.2013 11:34:45 (QP5 v5.163.1008.3004) */
  SELECT u1.fio p_fio,
         u1.e_mail p_mail,
         u.fio c_fio,
         u.e_mail c_mail,
         b.manual,
         u.dpt_id c_dpt_id,
         u.pos_name c_pos_name
    FROM dc_order_body b,
         user_list u,
         user_list u1,
         parents p
   WHERE b.head = :id AND u.tn = b.tn AND b.tn = p.tn AND u1.tn = p.parent AND b.manual >= 0
ORDER BY p_fio, c_fio