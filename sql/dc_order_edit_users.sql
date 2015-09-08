/* Formatted on 04.03.2013 13:28:28 (QP5 v5.163.1008.3004) */
  SELECT u.tn,
         u.tab_num,
         u.fio,
         u.pos_name,
         u.pos_id,
         TO_CHAR (u.start_pos, 'dd/mm/yyyy') start_pos,
         TO_CHAR (u.start_company, 'dd/mm/yyyy') start_company,
         u.dpt_id,
         b.manual
    FROM user_list u, dc_order_head h, dc_order_body b
   WHERE u.is_spd = 1 AND h.id = b.head AND h.id = :id AND b.tn = u.tn AND b.manual >= 0 AND u.datauvol IS NULL
ORDER BY u.fio, u.start_pos, u.start_company