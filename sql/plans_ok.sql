/* Formatted on 09/04/2015 14:25:27 (QP5 v5.227.12220.39724) */
  SELECT ROWNUM, z.*
    FROM (  SELECT DISTINCT
                   emp_tn,
                   fn_getdolgn (e.emp_tn) emp_dolgn,
                   fn_getname (e.emp_tn) emp_name,
                   NVL (
                      (SELECT plan_ok
                         FROM p_activ_plan_monthly m, calendar c
                        WHERE     m.m = c.my
                              AND m.y = c.y
                              AND c.DATA = TO_DATE (:DATA, 'dd.mm.yyyy')
                              AND m.tn = e.emp_tn),
                      0)
                      monthly_plan_ok,
                   CASE WHEN :exp_tn = 0 THEN 0 ELSE exp_tn END exp_tn_compare
              FROM emp_exp e, spdtree s, user_list u
             WHERE     exp_tn <> emp_tn
                   AND s.dpt_id = :dpt_id
                   AND s.svideninn = E.EMP_TN
                   AND u.tn = s.svideninn
                   AND NVL (u.is_top, 0) <> 1
          ORDER BY emp_name) z
   WHERE monthly_plan_ok = 0 AND exp_tn_compare = :exp_tn
ORDER BY emp_name