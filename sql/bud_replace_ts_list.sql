/* Formatted on 08.02.2013 11:37:55 (QP5 v5.163.1008.3004) */
  SELECT fio, tn
    FROM user_list
   WHERE is_ts = 1 AND NVL (tab_num, 0) <> 0
ORDER BY fio