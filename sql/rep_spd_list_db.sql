/* Formatted on 29/05/2015 12:42:29 (QP5 v5.227.12220.39724) */
  SELECT fio, tn
    FROM user_list
   WHERE is_db = 1 AND datauvol IS NULL AND dpt_id = 1
ORDER BY fio