/* Formatted on 16.09.2014 13:26:23 (QP5 v5.227.12220.39724) */
SELECT ac.*,
       t.comm,
       t.name,
       t.test_len,
       ROUND (t.test_len / 60) test_len_h
  FROM (SELECT id,
               ac_id,
               ac_test_logic,
               ac_test_math,
               LOGIC_TEST,
               MATH_TEST
          FROM ac_memb_ext
        UNION
        SELECT id,
               ac_id,
               ac_test_logic,
               ac_test_math,
               LOGIC_TEST,
               MATH_TEST
          FROM ac_memb_int) m,
       ac,
       ac_test t
 WHERE     ac.id = m.ac_id
       AND m.ac_id = :ac_id
       AND :ac_test_id = t.id
       AND (   :ac_test_id = m.ac_test_logic AND m.logic_test = 1
            OR :ac_test_id = m.ac_test_math AND m.math_test = 1)
       AND m.id = :memb_id