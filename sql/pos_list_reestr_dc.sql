/* Formatted on 02.07.2012 16:59:02 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT u.pos_id, u.pos_name
    FROM user_list u, os_head o
   WHERE u.dpt_id = :dpt_id AND u.pos_id = o.pos
ORDER BY u.pos_name