/* Formatted on 17.09.2012 15:35:39 (QP5 v5.163.1008.3004) */
SELECT ROWNUM - 1 num, tn
  FROM (  SELECT tn
            FROM bud_ru_zay_accept
           WHERE z_id = :id
             and child=0
        ORDER BY accept_order)