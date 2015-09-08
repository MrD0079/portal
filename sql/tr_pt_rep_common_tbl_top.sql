/* Formatted on 17.09.2013 12:35:00 (QP5 v5.227.12220.39724) */
  SELECT pos_id, pos_name, COUNT (*) cnt
    FROM user_list u
   WHERE is_spd = 1 AND datauvol IS NULL AND dpt_id = :dpt_id
GROUP BY pos_id, pos_name
ORDER BY pos_id, pos_name