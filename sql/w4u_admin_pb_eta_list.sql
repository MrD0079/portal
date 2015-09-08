/* Formatted on 29.03.2013 15:58:42 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT t.h_fio_eta,
                  t.fio_eta,
                  t.tab_num,
                  u.fio fio_ts
    FROM w4u_list t, user_list u
   WHERE t.tab_num = u.tab_num AND u.pos_id = 57 AND u.datauvol IS NULL AND u.dpt_id = :dpt_id
ORDER BY t.fio_eta