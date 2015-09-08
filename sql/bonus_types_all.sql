/* Formatted on 15/04/2015 17:53:16 (QP5 v5.227.12220.39724) */
           SELECT LEVEL, z.*
             FROM bonus_types z
       START WITH parent = 0
       CONNECT BY PRIOR id = parent
ORDER SIBLINGS BY name