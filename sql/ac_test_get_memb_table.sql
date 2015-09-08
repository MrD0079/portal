/* Formatted on 12/09/2014 13:17:57 (QP5 v5.227.12220.39724) */
SELECT 'ac_memb_int' table_name,
       CASE
          WHEN :ac_test_id = ac_test_logic THEN 'logic'
          WHEN :ac_test_id = ac_test_math THEN 'math'
       END
          test_type
  FROM ac_memb_int i
 WHERE i.id = :memb_id
UNION
SELECT 'ac_memb_ext' table_name,
       CASE
          WHEN :ac_test_id = ac_test_logic THEN 'logic'
          WHEN :ac_test_id = ac_test_math THEN 'math'
       END
          test_type
  FROM ac_memb_ext i
 WHERE i.id = :memb_id