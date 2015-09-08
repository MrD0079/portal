/* Formatted on 07.11.2013 16:52:05 (QP5 v5.227.12220.39724) */
           SELECT *
             FROM beg_to
            WHERE dpt_id = :dpt_id
       START WITH PARENT = 0
       CONNECT BY PRIOR ID = PARENT
ORDER SIBLINGS BY sort, name