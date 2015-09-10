/* Formatted on 19.06.2014 11:00:58 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT u.tn,
                  u.fio,
                  u.pos_name,
                  u.dpt_name,
                  d.sort
    FROM user_list u, departments d
   WHERE d.dpt_id = u.dpt_id AND u.tn > 0
ORDER BY d.sort, u.fio