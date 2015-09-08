/* Formatted on 07.02.2013 15:14:42 (QP5 v5.163.1008.3004) */
  SELECT tn, fio
    FROM user_list
   WHERE is_mkk = 1 OR is_rmkk = 1
ORDER BY fio