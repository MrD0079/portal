/* Formatted on 20.02.2015 9:55:56 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT pos_id, pos_name
    FROM user_list
   WHERE pos_id IS NOT NULL
ORDER BY pos_name