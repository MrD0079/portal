/* Formatted on 16.09.2013 14:18:53 (QP5 v5.227.12220.39724) */
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
         u.dpt_id,
         b.h_eta
    FROM user_list u, tr_pt_order_head h, tr_pt_order_body b
   WHERE h.id = b.head AND h.id = :id AND b.h_eta = u.h_eta AND b.manual >= 0
ORDER BY u.fio