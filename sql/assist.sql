/* Formatted on 07.09.2012 13:01:57 (QP5 v5.163.1008.3004) */
  SELECT e.*,
         fn_getname ( e.child) emp_name,
         fn_getname ( e.parent) exp_name,
         st_m.dpt_name dpt_name_m,
         st_x.dpt_name dpt_name_x
    FROM assist e, user_list st_m, user_list st_x
   WHERE     st_m.tn = e.child
         AND st_x.tn = e.parent
         AND e.dpt_id = :dpt_id
         /*AND (st_m.dpt_id = :dpt_id OR st_x.dpt_id = :dpt_id)*/
ORDER BY emp_name, exp_name