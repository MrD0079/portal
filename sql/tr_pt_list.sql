/* Formatted on 12.09.2013 14:12:43 (QP5 v5.227.12220.39724) */
  SELECT h.*,
         u.fio,
         tr.name,
         l.name loc_name,
         TO_CHAR (h.dt_start, 'dd/mm/yyyy') dt_start_t,
         (SELECT COUNT (*)
            FROM tr_pt_order_body
           WHERE head = h.id AND manual >= 0)
            stud_cnt,
         b.manual,
         b.h_eta stud_tn,
         u1.fio stud_fio,
         u1.pos_name stud_pos,
         c.id c_id,
         TO_CHAR (c.lu, 'dd/mm/yyyy hh24:mi:ss') c_lu,
         fn_getname ( c.tn) c_fio,
         c.text c_text
    FROM tr_pt_order_head h,
         tr_pt_order_body b,
         tr_pt_order_chat c,
         user_list u,
         tr,
         tr_loc l,
         user_list u1,
         (SELECT DISTINCT slave
            FROM full
           WHERE    master = :tn
                 OR (SELECT NVL (is_test_admin, 0)
                       FROM user_list
                      WHERE tn = :tn) = 1) w
   WHERE     TRUNC (h.dt_start, 'mm') BETWEEN TO_DATE (:sd, 'dd/mm/yyyy')
                                          AND TO_DATE (:ed, 'dd/mm/yyyy')
         AND u.tn = h.tn
         AND tr.id = h.tr
         AND h.loc = l.id
         AND h.id = b.head
         AND b.h_eta = u1.h_eta
         AND h.id = c.head(+)
         AND DECODE (:tr_tn, 0, h.tn, :tr_tn) = h.tn
         AND DECODE (:tr, 0, h.tr, :tr) = h.tr
         AND DECODE (:tr_loc, 0, h.loc, :tr_loc) = h.loc
         AND u.tn = w.slave
ORDER BY h.dt_start,
         h.id,
         u1.fio,
         c.id