/* Formatted on 30.07.2013 15:43:54 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT u.pos_id, u.pos_name
    FROM tr_order_body tb, user_list u
   WHERE tb.manual >= 0 AND u.tn = tb.tn AND u.dpt_id = :dpt_id
ORDER BY u.pos_name