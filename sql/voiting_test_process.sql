/* Formatted on 11/04/2016 17:43:14 (QP5 v5.252.13127.32867) */
           SELECT *
             FROM (SELECT qa.*
                     FROM tr_test_qa qa
                    WHERE qa.tr = :id)
       START WITH TYPE = 5
       CONNECT BY PRIOR id_num = parent
ORDER SIBLINGS BY DBMS_RANDOM.string (NULL, 32)