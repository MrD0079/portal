/* Formatted on 28.09.2012 10:39:28 (QP5 v5.163.1008.3004) */
  SELECT *
    FROM user_list u
   WHERE u.is_db = 1
     AND u.dpt_id=:dpt_id
ORDER BY fio