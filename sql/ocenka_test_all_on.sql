/* Formatted on 11.06.2014 9:39:30 (QP5 v5.227.12220.39724) */
INSERT INTO ocenka_test_list (tn)
     SELECT e.emp_tn
       FROM emp_exp e, user_list u
      WHERE e.emp_tn = u.tn AND u.dpt_id = :dpt_id AND u.datauvol IS NULL
   GROUP BY e.emp_tn