/* Formatted on 31.01.2013 11:41:39 (QP5 v5.163.1008.3004) */
  SELECT *
    FROM user_list
   WHERE NVL (is_coach, 0) = 1 AND datauvol IS NULL AND dpt_id = :dpt_id
ORDER BY fio