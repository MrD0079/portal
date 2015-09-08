/* Formatted on 16.09.2013 15:04:09 (QP5 v5.227.12220.39724) */
SELECT *
  FROM (  SELECT h.id
            FROM tr_pt_order_head h, tr_pt_order_body b
           WHERE     h.id = b.head
                 AND b.h_eta = :h_eta
                 AND b.manual >= 0
                 AND b.test = 1
                 AND h.completed = 1
        ORDER BY dt_start)
 WHERE ROWNUM = 1