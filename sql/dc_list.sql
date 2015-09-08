/* Formatted on 04.03.2013 13:49:40 (QP5 v5.163.1008.3004) */
  SELECT h.*,
         u.fio,
         l.name loc_name,
         TO_CHAR (h.dt_start, 'dd/mm/yyyy') dt_start_t,
         (SELECT COUNT (*)
            FROM dc_order_body
           WHERE head = h.id AND manual >= 0)
            stud_cnt,
         b.manual,
         b.tn stud_tn,
         u1.fio stud_fio,
         u1.pos_name stud_pos,
         CASE WHEN h.dt_start < TRUNC (SYSDATE) THEN 1 ELSE 0 END readonly
    FROM dc_order_head h,
         dc_order_body b,
         user_list u,
         tr_loc l,
         user_list u1
   WHERE     TRUNC (h.dt_start, 'mm') BETWEEN TO_DATE (:sd, 'dd/mm/yyyy') AND TO_DATE (:ed, 'dd/mm/yyyy')
         AND u.tn = h.tn
         AND h.loc = l.id
         AND h.id = b.head
         AND b.tn = u1.tn
         AND DECODE (:dc_tn, 0, h.tn, :dc_tn) = h.tn
         AND DECODE (:dc_loc, 0, h.loc, :dc_loc) = h.loc
         AND DECODE (:pos, 0, u1.pos_id, :pos) = u1.pos_id
         AND u.tn IN (SELECT slave
                        FROM full
                       WHERE master = :tn)
ORDER BY h.dt_start, h.id, u1.fio