/* Formatted on 11.06.2014 9:38:26 (QP5 v5.227.12220.39724) */
  SELECT ROWNUM, z.*
    FROM (  SELECT e.emp_tn,
                   fn_getname ( e.emp_tn) emp_name,
                   (SELECT COUNT (*)
                      FROM ocenka_test_list
                     WHERE tn = e.emp_tn)
                      TEST,
                   s.login,
                   s.PASSWORD
              FROM emp_exp e, user_list s
             WHERE e.emp_tn = s.tn AND s.dpt_id = :dpt_id AND s.datauvol IS NULL
          GROUP BY e.emp_tn, s.login, s.PASSWORD) z
ORDER BY emp_name