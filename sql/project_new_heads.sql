/* Formatted on 23.10.2012 14:40:22 (QP5 v5.163.1008.3004) */
           SELECT LEVEL, z.*
             FROM project z
            WHERE LEVEL = 1
       START WITH PARENT = 0 AND dpt_id=:dpt_id
       CONNECT BY PRIOR ID = PARENT
ORDER SIBLINGS BY sort