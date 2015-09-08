/* Formatted on 19.06.2014 11:01:47 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT u.pos_id, u.pos_name
    FROM user_list u
   WHERE u.tn > 0 AND u.pos_name IS NOT NULL
ORDER BY u.pos_name