/* Formatted on 24.09.2013 14:34:13 (QP5 v5.227.12220.39724) */
SELECT u.fio, u.pos_name, pr.val_string e_mail
  FROM tr_pt_order_body b, user_list u, parameters pr
 WHERE     b.head = :id
       AND u.h_eta = b.h_eta
       AND b.manual >= 0
       AND b.completed = 1
       AND pr.dpt_id = u.dpt_id
       AND pr.param_name IN ('accept1', 'accept2')
       AND b.test = 0