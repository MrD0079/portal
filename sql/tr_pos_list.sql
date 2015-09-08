/* Formatted on 21.12.2012 16:28:48 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT pos_id, pos_name
    FROM user_list
   WHERE dpt_id = :dpt_id
ORDER BY pos_name