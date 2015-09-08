/* Formatted on 09/04/2015 13:01:31 (QP5 v5.227.12220.39724) */
  SELECT ROWNUM, z.*
    FROM (  SELECT fn_getdolgn (s.svideninn) emp_dolgn,
                   fn_getdolgnid (s.svideninn) emp_dolgn_id,
                   CASE
                      WHEN :dolgn_id <> 0 THEN :dolgn_id
                      ELSE fn_getdolgnid (s.svideninn)
                   END
                      dolgn_compare,
                   fn_getname (s.svideninn) emp_name,
                   s.svideninn emp_tn,
                   (SELECT city
                      FROM p_activ_plan_daily
                     WHERE     tn = s.svideninn
                           AND DATA = TO_DATE (:DATA, 'dd.mm.yyyy'))
                      daily_plans_city,
                   (SELECT PLAN
                      FROM p_activ_plan_daily
                     WHERE     tn = s.svideninn
                           AND DATA = TO_DATE (:DATA, 'dd.mm.yyyy'))
                      daily_plans_plan,
                   CASE
                      WHEN :exist_daily_plans_count = 0
                      THEN
                         0
                      WHEN :exist_daily_plans_count = 1
                      THEN
                         CASE
                            WHEN (SELECT COUNT (*)
                                    FROM p_activ_plan_daily
                                   WHERE     tn = s.svideninn
                                         AND TRUNC (DATA, 'mm') =
                                                TO_DATE (:DATA, 'dd.mm.yyyy')) >
                                    0
                            THEN
                               1
                            ELSE
                               0
                         END
                      WHEN :exist_daily_plans_count = -1
                      THEN
                         CASE
                            WHEN (SELECT COUNT (*)
                                    FROM p_activ_plan_daily
                                   WHERE     tn = s.svideninn
                                         AND TRUNC (DATA, 'mm') =
                                                TO_DATE (:DATA, 'dd.mm.yyyy')) =
                                    0
                            THEN
                               -1
                            ELSE
                               0
                         END
                   END
                      daily_plans_count_compare,
                   (SELECT COUNT (*)
                      FROM p_activ_plan_daily
                     WHERE     tn = s.svideninn
                           AND TRUNC (DATA, 'mm') = TO_DATE (:DATA, 'dd.mm.yyyy'))
                      daily_plans_count,
                   (SELECT COUNT (*)
                      FROM p_activ_plan_weekly
                     WHERE tn = s.svideninn)
                      weekly_plans_count
              FROM (SELECT DISTINCT emp_tn FROM emp_exp) e,
                   spdtree s,
                   user_list u
             WHERE     s.svideninn = s.svideninn
                   AND e.emp_tn = s.svideninn
                   AND s.dpt_id = :dpt_id
                   AND u.tn = s.svideninn
                   AND NVL (u.is_top, 0) <> 1
          ORDER BY emp_name) z
   WHERE     emp_dolgn_id = dolgn_compare
         AND daily_plans_count_compare = :exist_daily_plans_count
ORDER BY emp_name