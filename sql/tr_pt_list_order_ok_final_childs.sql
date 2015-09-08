/* Formatted on 13/09/2013 13:37:13 (QP5 v5.227.12220.39724) */
  SELECT u.fio c_fio, u.e_mail c_mail, u.pos_name c_pos
    FROM tr_pt_order_body b, user_list u
   WHERE b.head = :id AND u.h_eta = b.h_eta AND b.manual <> -1
ORDER BY c_fio