/* Formatted on 18.11.2013 13:52:10 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT s.tn,
                  u.fio,
                  u.pos_name,
                  u.dpt_name,
                  d.sort
    FROM sz_executors s, user_list u, departments d
   WHERE s.tn = u.tn AND d.dpt_id = u.dpt_id AND u.is_spd = 1
ORDER BY d.sort, u.fio