/* Formatted on 20.02.2015 9:55:38 (QP5 v5.227.12220.39724) */
  SELECT u.fio, u.tn, d.*
    FROM user_list u, departments d
   WHERE u.datauvol IS NULL AND u.dpt_id = d.dpt_id AND u.is_spd = 1
ORDER BY d.sort, u.fio