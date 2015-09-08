/* Formatted on 17.11.2014 13:01:12 (QP5 v5.227.12220.39724) */
           SELECT LEVEL, qa.*
             FROM prob_test qa
       /*WHERE LEVEL = 1*/
       START WITH qa.parent = (SELECT test_id
                                 FROM p_plan
                                WHERE tn = :tn)
       CONNECT BY PRIOR qa.id = qa.parent
ORDER SIBLINGS BY DBMS_RANDOM.string (NULL, 32)