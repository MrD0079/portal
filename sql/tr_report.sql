/* Formatted on 30.01.2013 13:22:12 (QP5 v5.163.1008.3004) */
  SELECT b.id,
         b.completed,
         b.os,
         b.test,
         TO_CHAR (b.test_lu, 'dd/mm/yyyy hh24:mi:ss') test_lu,
         u.tn,
         u.tab_num,
         u.fio,
         u.pos_name,
         u.pos_id,
         u.dpt_id,
         b.test_count
    FROM user_list u, tr_order_head h, tr_order_body b
   WHERE h.id = b.head AND h.id = :id AND b.tn = u.tn AND b.manual >= 0
ORDER BY u.fio