/* Formatted on 22.01.2013 8:57:52 (QP5 v5.163.1008.3004) */
SELECT *
  FROM (  SELECT h.id
            FROM tr_order_head h, tr_order_body b
           WHERE h.id = b.head AND b.tn = :tn AND b.manual >= 0 AND b.test = 1 AND h.completed = 1
        ORDER BY dt_start)
 WHERE ROWNUM = 1