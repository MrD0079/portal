/* Formatted on 04.03.2013 11:25:06 (QP5 v5.163.1008.3004) */
  SELECT u.fio c_fio, u.e_mail c_mail
    FROM dc_order_body b, user_list u
   WHERE b.head = :id AND u.tn = b.tn AND b.manual <> -1
ORDER BY c_fio