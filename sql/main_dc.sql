/* Formatted on 05.04.2013 16:04:33 (QP5 v5.163.1008.3004) */
  SELECT b.tn stud_tn,
         u1.fio stud_fio,
         u1.pos_name stud_pos,
         TO_CHAR (h.dt_start, 'dd.mm.yyyy') dt_start,
         l.name loc_name
    FROM dc_order_head h,
         dc_order_body b,
         user_list u,
         tr_loc l,
         user_list u1
   WHERE     h.dt_start >= TRUNC (SYSDATE)
         AND u.tn = h.tn
         AND h.loc = l.id
         AND h.id = b.head
         AND b.tn = u1.tn
         AND u1.tn IN (SELECT slave
                         FROM full
                        WHERE master = :tn AND full <> 0)
         AND b.manual >= 0
ORDER BY h.dt_start, h.id, u1.fio