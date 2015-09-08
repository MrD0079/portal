/* Formatted on 18.01.2013 10:06:42 (QP5 v5.163.1008.3004) */
  SELECT TO_CHAR (c.lu, 'dd/mm/yyyy hh24:mi:ss') lu, u.fio, c.text
    FROM tr_order_chat c, user_list u
   WHERE c.head = :id AND u.tn = c.tn
ORDER BY c.id