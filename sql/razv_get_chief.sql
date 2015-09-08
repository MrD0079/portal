/* Formatted on 21/08/2014 10:45:13 (QP5 v5.227.12220.39724) */
SELECT (SELECT COUNT (*) c
          FROM emp_exp
         WHERE FULL = 1 AND emp_tn = x.exp_tn AND exp_tn = :exp_tn)
  FROM emp_exp x
 WHERE FULL = 1 AND emp_tn = :emp_tn