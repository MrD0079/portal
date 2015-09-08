/* Formatted on 14/04/2015 13:22:25 (QP5 v5.227.12220.39724) */
  SELECT tn,
         emp_name,
         emp_svid,
         daily_plans_count,
         weekly_plans_count,
         monthly_plan_ok,
         readonly readonly,
         full,
         DECODE (daily_plans_count + weekly_plans_count, 0, 0, 1) pa_zapolnen
    FROM (  SELECT e.tn,
                   fn_getname (e.tn) emp_name,
                   e.tn emp_svid,
                   (SELECT COUNT (*)
                      FROM p_activ_plan_daily
                     WHERE tn = e.tn)
                      daily_plans_count,
                   (SELECT COUNT (*)
                      FROM p_activ_plan_weekly w
                     WHERE tn = e.tn)
                      weekly_plans_count,
                   (SELECT plan_ok
                      FROM p_activ_plan_monthly m, calendar c
                     WHERE     m.m = c.my
                           AND m.y = c.y
                           AND c.DATA = TO_DATE (:sd, 'dd.mm.yyyy')
                           AND m.tn = e.tn)
                      monthly_plan_ok,
                   DECODE (full, 1, 0, 1) readonly,
                   full
              FROM (SELECT DISTINCT f.full, f.slave tn
                      FROM full f, user_list u
                     WHERE     f.dpt_id = :dpt_id
                           AND f.master = :tn
                           AND u.tn = f.slave
                           AND NVL (u.is_top, 0) <> 1
                           AND NVL (ADD_MONTHS (TRUNC (u.datauvol, 'mm'), 1),
                                    TO_DATE (:sd, 'dd.mm.yyyy')) >=
                                  TO_DATE (:sd, 'dd.mm.yyyy')) e,
                   user_list u
             WHERE e.tn = u.tn AND NVL (u.is_top, 0) <> 1
          ORDER BY emp_name) z
ORDER BY emp_name