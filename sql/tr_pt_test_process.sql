/* Formatted on 21.03.2014 11:47:18 (QP5 v5.227.12220.39724) */
           SELECT *
             FROM (SELECT qa.*
                     FROM tr_pt_order_head h,
                          tr_pt_order_body b,
                          tr,
                          tr_test_qa qa
                    WHERE     h.id = b.head
                          AND b.h_eta = :h_eta
                          AND b.manual >= 0
                          AND b.test = 1
                          AND h.completed = 1
                          AND tr.id = h.tr
                          AND qa.tr = tr.id
                          AND h.id =
                                 (SELECT id
                                    FROM (  SELECT h.id
                                              FROM tr_pt_order_head h, tr_pt_order_body b
                                             WHERE     h.id = b.head
                                                   AND b.h_eta = :h_eta
                                                   AND b.manual >= 0
                                                   AND b.test = 1
                                                   AND h.completed = 1
                                          ORDER BY dt_start)
                                   WHERE ROWNUM = 1))
       START WITH TYPE = 5
       CONNECT BY PRIOR id_num = parent
ORDER SIBLINGS BY DBMS_RANDOM.string (NULL, 32)