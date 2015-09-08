/* Formatted on 25.12.2012 13:54:50 (QP5 v5.163.1008.3004) */
  SELECT *
    FROM user_list
   WHERE tn IN (SELECT DISTINCT parent FROM parents) AND dpt_id = :dpt_id
ORDER BY fio