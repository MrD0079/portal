/* Formatted on 28.09.2012 10:39:28 (QP5 v5.163.1008.3004) */
  SELECT *
    FROM user_list u
   WHERE u.is_mz = 1 or u.is_mz_admin = 1 or u.is_mz_buh = 1
ORDER BY fio