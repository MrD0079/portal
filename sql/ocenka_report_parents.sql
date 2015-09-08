/* Formatted on 23.01.2013 9:52:31 (QP5 v5.163.1008.3004) */
  SELECT *
    FROM user_list u
   WHERE     tn IN (SELECT DISTINCT parent FROM parents)
         AND dpt_id = :dpt_id
         AND tn IN (SELECT slave
                      FROM full
                     WHERE master = :tn)
         AND u.datauvol IS NULL
ORDER BY fio