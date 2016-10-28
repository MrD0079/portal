/* Formatted on 03/02/2016 16:23:14 (QP5 v5.252.13127.32867) */
SELECT ROWNUM - 1 num, tn
  FROM (  SELECT tn
            FROM bud_ru_zay_executors
           WHERE z_id = :id
        ORDER BY execute_order)