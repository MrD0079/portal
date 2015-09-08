/* Formatted on 12/09/2014 12:02:49 (QP5 v5.227.12220.39724) */
           SELECT LEVEL, qa.*
             FROM (SELECT id,
                          ac_id,
                          ac_test_logic,
                          ac_test_math,
                          LOGIC_TEST,
                          MATH_TEST
                     FROM ac_memb_ext
                    WHERE     (math_test = 1 OR logic_test = 1)
                          AND id = :memb_id
                          AND :ac_test_id IN (ac_test_logic, ac_test_math)
                   UNION
                   SELECT id,
                          ac_id,
                          ac_test_logic,
                          ac_test_math,
                          LOGIC_TEST,
                          MATH_TEST
                     FROM ac_memb_int
                    WHERE     (math_test = 1 OR logic_test = 1)
                          AND id = :memb_id
                          AND :ac_test_id IN (ac_test_logic, ac_test_math)) members,
                  ac_test qa
            /*WHERE LEVEL = 1*/
       START WITH qa.parent = :ac_test_id
       CONNECT BY PRIOR qa.id = qa.parent
ORDER SIBLINGS BY DBMS_RANDOM.string (NULL, 32)