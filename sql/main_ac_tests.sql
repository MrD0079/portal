/* Formatted on 12/09/2014 13:55:46 (QP5 v5.227.12220.39724) */
SELECT i.ac_test_logic,
       i.ac_test_math,
       i.id,
       i.tn,
       i.ac_id,
       i.logic_test,
       i.math_test
  FROM ac, ac_memb_int i
 WHERE     ac.id = i.ac_id
       AND TRUNC (SYSDATE) BETWEEN ac.dt AND ac.dt + 15
       AND (i.logic_test = 1 OR i.math_test = 1)
       AND i.tn = :tn