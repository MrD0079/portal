/* Formatted on 28.10.2014 18:22:30 (QP5 v5.227.12220.39724) */
  SELECT e.emp_tn, fn_getname (e.emp_tn) emp_name, s.dolgn
    FROM emp_exp e, spdtree s, free_staff f
   WHERE     (   e.exp_tn = :tn
              OR (SELECT NVL (is_do, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND e.exp_tn <> e.emp_tn
         AND e.emp_tn = s.svideninn
         AND e.full = 1
         AND s.datauvol IS NULL
         AND e.emp_tn = f.tn(+)
         AND f.tn IS NULL
ORDER BY emp_name