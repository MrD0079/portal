/* Formatted on 25.12.2012 13:54:07 (QP5 v5.163.1008.3004) */
  SELECT *
    FROM user_list
   WHERE tn IN (SELECT DISTINCT parent FROM parents)
ORDER BY fio