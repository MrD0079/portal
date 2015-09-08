/* Formatted on 09/04/2015 13:57:36 (QP5 v5.227.12220.39724) */
  SELECT ROWNUM,
         q1.tn,
         q1.wm,
         q1.ID,
         q1.NAME,
         p.PLAN,
         p.fakt,
         fn_getdolgn (q1.tn) emp_dolgn,
         fn_getname (q1.tn) emp_name
    FROM (SELECT q.*,
                 fn_getdolgnid (q.tn) emp_dolgn_id,
                 CASE
                    WHEN :dolgn_id <> 0 THEN :dolgn_id
                    ELSE fn_getdolgnid (q.tn)
                 END
                    dolgn_compare
            FROM (  SELECT DISTINCT c.wm,
                                    e.emp_tn tn,
                                    t.ID,
                                    t.NAME
                      FROM calendar c,
                           emp_exp e,
                           p_activ_types t,
                           spdtree s
                     WHERE     TO_DATE ('01' || '.' || c.my || '.' || c.y,
                                        'dd.mm.yy') =
                                  TO_DATE (:month_list, 'dd.mm.yyyy')
                           AND s.dpt_id = :dpt_id
                           AND s.svideninn = E.EMP_TN
                  ORDER BY e.emp_tn, c.wm, t.ID) q) q1,
         (SELECT tn,
                 p_activ_type_id,
                 PLAN,
                 fakt,
                 w
            FROM p_activ_plan_weekly
           WHERE TO_DATE ('01' || '.' || m || '.' || y, 'dd.mm.yy') =
                    TO_DATE (:month_list, 'dd.mm.yyyy')) p
   WHERE     p.tn(+) = q1.tn
         AND p.p_activ_type_id(+) = q1.ID
         AND p.w(+) = q1.wm
         AND emp_dolgn_id = dolgn_compare
ORDER BY emp_name,
         q1.tn,
         q1.wm,
         q1.NAME