/* Formatted on 10.01.2013 13:49:28 (QP5 v5.163.1008.3004) */
  SELECT u.fio, u.tn
    FROM user_list u
   WHERE u.datauvol IS NULL AND u.is_spd = 1
ORDER BY fio