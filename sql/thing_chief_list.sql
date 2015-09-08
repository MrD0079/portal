/* Formatted on 11.01.2013 13:46:26 (QP5 v5.163.1008.3004) */
SELECT *
  FROM user_list u
 WHERE     u.dpt_id = :dpt_id
       AND (u.tn IN (SELECT emp_tn
                       FROM (    SELECT LPAD (z.emp, LENGTH (z.emp) + (LEVEL) * 3, '-'), LEVEL, z.*
                                   FROM (SELECT fn_getname ( exp_tn) EXP,
                                                fn_getname ( emp_tn) emp,
                                                exp_tn,
                                                emp_tn,
                                                full
                                           FROM emp_exp
                                          WHERE full = 1 AND exp_tn <> emp_tn) z
                             START WITH exp_tn = :tn
                             CONNECT BY PRIOR emp_tn = exp_tn)
                     UNION
                     SELECT :tn FROM DUAL)
            OR (SELECT NVL (is_super, 0) + NVL (is_traid, 0)
                  FROM user_list
                 WHERE tn = :tn) > 0)
       AND pos_id IN (27, 33, 56)