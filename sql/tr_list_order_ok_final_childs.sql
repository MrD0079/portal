/* Formatted on 04.01.2013 14:07:39 (QP5 v5.163.1008.3004) */
  SELECT u.fio c_fio, u.e_mail c_mail, u.pos_name c_pos
    FROM tr_order_body b, user_list u
   WHERE b.head = :id AND u.tn = b.tn AND b.manual <> -1
ORDER BY c_fio