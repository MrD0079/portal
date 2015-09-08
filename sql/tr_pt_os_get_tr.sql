/* Formatted on 16.09.2013 15:04:23 (QP5 v5.227.12220.39724) */
SELECT *
  FROM (  SELECT h.id,
                 b.S_CJ,
                 b.S_TM,
                 b.S_TO,
                 b.W_CJ,
                 b.W_TM,
                 b.W_TO,
                 TO_CHAR (b.test_lu + 48 / 24, 'dd.mm.yyyy hh24:mi:ss')
                    end_time
            FROM tr_pt_order_head h, tr_pt_order_body b
           WHERE     h.id = b.head
                 AND b.h_eta = :h_eta
                 AND b.manual >= 0
                 AND b.test = 1
                 AND h.completed = 1
        ORDER BY dt_start)
 WHERE ROWNUM = 1