/* Formatted on 21/08/2014 10:46:09 (QP5 v5.227.12220.39724) */
SELECT COUNT (*) c
  FROM emp_exp
 WHERE FULL = 1 AND emp_tn = :emp_tn AND exp_tn = :exp_tn