/* Formatted on 09/04/2015 13:28:12 (QP5 v5.227.12220.39724) */
SELECT ROWNUM, z.*
  FROM (  SELECT e.*,
                 fn_getname (e.emp_tn) emp_name,
                 fn_getdolgn (e.emp_tn) emp_dolgn,
                 fn_getname (e.exp_tn) exp_name,
                 emp_tn emp_svid,
                 exp_tn exp_svid,
                 (SELECT city
                    FROM p_activ_plan_daily
                   WHERE tn = e.emp_tn AND DATA = TO_DATE (:DATA, 'dd.mm.yyyy'))
                    daily_plans_city,
                 (SELECT PLAN
                    FROM p_activ_plan_daily
                   WHERE tn = e.emp_tn AND DATA = TO_DATE (:DATA, 'dd.mm.yyyy'))
                    daily_plans_plan,
                 (SELECT COUNT (*)
                    FROM p_activ_plan_daily
                   WHERE tn = e.emp_tn)
                    daily_plans_count,
                 (SELECT COUNT (*)
                    FROM p_activ_plan_weekly
                   WHERE tn = e.emp_tn)
                    weekly_plans_count
            FROM emp_exp e, user_list u
           WHERE     FULL = 1
                 AND exp_tn = :exp_tn
                 AND exp_tn <> emp_tn
                 AND u.tn = e.emp_tn
                 AND u.dpt_id = :dpt_id
        ORDER BY exp_name, emp_name) z
 WHERE daily_plans_count > 0 OR weekly_plans_count > 0