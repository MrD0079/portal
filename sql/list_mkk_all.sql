/* Formatted on 27/04/2015 17:07:49 (QP5 v5.227.12220.39724) */
  SELECT fio, tn, dpt_name
    FROM user_list
   WHERE is_mkk = 1 AND datauvol IS NULL
ORDER BY fio