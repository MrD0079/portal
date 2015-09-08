/* Formatted on 17.09.2012 15:36:04 (QP5 v5.163.1008.3004) */
SELECT ROWNUM - 1 num, tn
  FROM (  SELECT tn
            FROM sz_executors
           WHERE sz_id = :id
        ORDER BY execute_order)