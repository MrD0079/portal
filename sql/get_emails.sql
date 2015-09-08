/* Formatted on 11.01.2013 13:11:17 (QP5 v5.163.1008.3004) */
SELECT email
  FROM spdtree
 WHERE svideninn IN (:tn, (SELECT exp_tn
                             FROM emp_exp
                            WHERE emp_tn = :tn AND full = 1))