/* Formatted on 10.01.2013 13:45:19 (QP5 v5.163.1008.3004) */
  SELECT u.fio, u.tn, d.*
    FROM user_list u, departments d
   WHERE u.dpt_id = d.dpt_id AND u.is_spd = 1
ORDER BY d.sort, u.fio
