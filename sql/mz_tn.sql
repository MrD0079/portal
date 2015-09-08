/* Formatted on 28.09.2012 10:22:43 (QP5 v5.163.1008.3004) */
  SELECT e.*,
         fn_getname ( e.tn) emp_name,
         mz.name mz_name,
         st_m.dpt_name dpt_name
    FROM mz_tn e, user_list st_m, mz_spr_mz mz
   WHERE st_m.tn = e.tn AND st_m.dpt_id = :dpt_id AND mz.id = e.mz_id
ORDER BY mz.name, emp_name