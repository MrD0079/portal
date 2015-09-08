/* Formatted on 18.11.2013 13:51:26 (QP5 v5.227.12220.39724) */
  SELECT u.tn,
         u.fio,
         u.pos_name,
         u.dpt_name,
         d.sort
    FROM user_list u, departments d
   WHERE d.dpt_id = u.dpt_id AND u.datauvol IS NULL AND u.is_spd = 1
ORDER BY d.sort, u.fio