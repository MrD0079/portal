/* Formatted on 17.09.2013 12:33:04 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT u.pos_id, u.pos_name
    FROM tr_pt_order_body tb, user_list u
   WHERE tb.manual >= 0 AND u.h_eta = tb.h_eta AND u.dpt_id = :dpt_id
ORDER BY u.pos_name