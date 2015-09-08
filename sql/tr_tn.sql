/* Formatted on 18.01.2013 15:21:37 (QP5 v5.163.1008.3004) */
  SELECT *
    FROM user_list
   WHERE is_coach = 1
         AND tn IN (SELECT slave
                      FROM full
                     WHERE master = :tn)
ORDER BY fio