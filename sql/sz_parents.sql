/* Formatted on 11.01.2013 12:52:32 (QP5 v5.163.1008.3004) */
SELECT z.*, fn_getname ( parent) parent_name, fn_getname ( id) child_name
  FROM (SELECT DISTINCT exp_tn parent, emp_tn id
          FROM emp_exp
         WHERE full = 1) z
 WHERE id = :tn