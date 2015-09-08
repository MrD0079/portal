/* Formatted on 19/09/2014 12:36:59 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT u.res_pos_id, u.res_pos_name
    FROM user_list u
   WHERE u.res_pos_id IS NOT NULL
ORDER BY u.res_pos_name