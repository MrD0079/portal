/* Formatted on 28.01.2013 13:36:45 (QP5 v5.163.1008.3004) */
  SELECT h.*,
         b.id,
         b.completed,
         b.os,
         b.test,
         TO_CHAR (b.test_lu, 'dd/mm/yyyy hh24:mi:ss') test_lu,
         b.s_cj,
         b.s_tm,
         b.s_to,
         b.w_cj,
         b.w_tm,
         b.w_to,
         b.test_ball,
         b.test_count,
         u.tn,
         u.tab_num,
         u.fio,
         u.pos_name,
         u.pos_id,
         u.dpt_id
    FROM user_list u, tr_order_head h, tr_order_body b
   WHERE h.id = b.head AND h.id = :id AND b.tn = u.tn AND b.manual >= 0
ORDER BY u.fio