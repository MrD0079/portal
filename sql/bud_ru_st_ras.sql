/* Formatted on 20/01/2016 10:54:32 (QP5 v5.252.13127.32867) */
           SELECT s.*,
                  (SELECT COUNT (*)
                     FROM bud_ru_st_ras
                    WHERE tu = 1 AND parent = s.id)
                     tu_child_cnt
             FROM bud_ru_st_ras s
            WHERE dpt_id = :dpt_id
       START WITH PARENT = 0
       CONNECT BY PRIOR ID = PARENT
ORDER SIBLINGS BY sort, name