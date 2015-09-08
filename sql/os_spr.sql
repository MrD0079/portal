/* Formatted on 02.07.2012 15:21:37 (QP5 v5.163.1008.3004) */
           SELECT LEVEL, z.*
             FROM os_spr z
       START WITH PARENT = 0
       CONNECT BY PRIOR ID = PARENT
ORDER SIBLINGS BY sort