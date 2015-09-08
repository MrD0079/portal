/* Formatted on 26/05/2015 11:49:09 (QP5 v5.227.12220.39724) */
  SELECT u.pos_id,
         u.pos_name,
         COUNT (*) c,
         p.val,
         TO_CHAR (p.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
         p.lu_fio
    FROM user_list u, advance_pos p
   WHERE     u.datauvol IS NULL
         AND u.is_spd = 1
         AND u.pos_id IS NOT NULL
         AND u.dpt_id = :dpt_id
         AND u.pos_id = p.pos_id(+)
         AND u.dpt_id = p.dpt_id(+)
GROUP BY u.pos_id,
         u.pos_name,
         p.val,
         p.lu,
         p.lu_fio
ORDER BY u.pos_name