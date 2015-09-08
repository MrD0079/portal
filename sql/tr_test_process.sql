/* Formatted on 22.01.2013 13:22:31 (QP5 v5.163.1008.3004) */
           SELECT *
             FROM (SELECT qa.*
                     FROM tr_order_head h,
                          tr_order_body b,
                          tr,
                          tr_test_qa qa
                    WHERE h.id = b.head AND b.tn = :tn AND b.manual >= 0 AND b.test = 1 AND h.completed = 1 AND tr.id = h.tr AND qa.tr = tr.id)
       START WITH TYPE = 5
       CONNECT BY PRIOR id_num = parent
ORDER SIBLINGS BY DBMS_RANDOM.string (NULL, 32)