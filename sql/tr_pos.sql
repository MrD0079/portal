/* Formatted on 14.01.2013 14:58:04 (QP5 v5.163.1008.3004) */
  SELECT e.*,
         tr.name tr_name,
         p.pos_name,
         TO_CHAR (e.lu, 'dd/mm/yyyy hh24:mi:ss') lu_txt
    FROM tr_pos e, pos p, tr
   WHERE     p.pos_id = e.pos_id
         AND tr.id = e.tr_id
         AND e.pos_id IN (SELECT DISTINCT pos_id
                            FROM user_list
                           WHERE dpt_id = :dpt_id)
ORDER BY p.pos_name, e.sort