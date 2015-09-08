/* Formatted on 11.12.2014 13:10:51 (QP5 v5.227.12220.39724) */
SELECT p.test_ball,
       TO_CHAR (p.test_lu, 'dd.mm.yyyy hh24:mi:ss') test_lu,
       (SELECT COUNT (*)
          FROM prob_test
         WHERE parent = p.test_id)
          max_ball,
       DECODE (NVL ( (SELECT COUNT (*)
                        FROM prob_test
                       WHERE parent = p.test_id),
                    0),
               0, 0,
                 p.test_ball
               / (SELECT COUNT (*)
                    FROM prob_test
                   WHERE parent = p.test_id)
               * 100)
          perc
  FROM p_plan p
 WHERE p.tn = :tn