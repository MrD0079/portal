/* Formatted on 15.01.2013 13:35:44 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT tn exp_svid, fio exp_name
    FROM user_list u, emp_exp e
   WHERE dpt_id = :dpt_id AND datauvol IS NULL AND is_spd = 1 AND u.tn = e.exp_tn AND exp_tn <> emp_tn
ORDER BY exp_name