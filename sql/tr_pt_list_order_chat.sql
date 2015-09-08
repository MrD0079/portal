/* Formatted on 13.09.2013 9:06:34 (QP5 v5.227.12220.39724) */
  SELECT TO_CHAR (c.lu, 'dd/mm/yyyy hh24:mi:ss') lu, u.fio, c.text
    FROM tr_pt_order_chat c, user_list u
   WHERE c.head = :id AND u.tn = c.tn
ORDER BY c.id