/* Formatted on 07/04/2015 11:34:32 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT u.tn, u.fio, u.pos_name
    FROM routes r, user_list u, departments d
   WHERE     r.tab_number = u.tab_num
         AND u.dpt_id = :dpt_id
         AND u.datauvol IS NULL
         AND u.is_ts = 1
         AND d.manufak = r.country
         AND d.dpt_id = :dpt_id
ORDER BY u.fio