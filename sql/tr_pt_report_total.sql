/* Formatted on 16.09.2013 13:07:01 (QP5 v5.227.12220.39724) */
  SELECT h.*,
         u.fio,
         tr.name,
         l.name loc_name,
         TO_CHAR (h.dt_start, 'dd/mm/yyyy') dt_start_t,
         TO_CHAR (h.dt_start + tr.days - 1, 'dd/mm/yyyy') dt_end_t,
         (SELECT NVL (COUNT (*), 0)
            FROM tr_pt_order_body
           WHERE head = h.id AND manual >= 0)
            stud_cnt,
         (SELECT NVL (COUNT (*), 0)
            FROM tr_pt_order_body
           WHERE head = h.id AND manual >= 0 AND completed = 1)
            stud_cnt_fakt,
         (SELECT NVL (COUNT (*), 0)
            FROM tr_pt_order_body
           WHERE head = h.id AND manual >= 0 AND completed = 1 AND test = 2)
            stud_cnt_test_ok,
         (SELECT NVL (AVG (test_ball), 0)
            FROM tr_pt_order_body
           WHERE head = h.id AND manual >= 0 AND completed = 1 AND test = 2)
            avg_ball,
         (SELECT NVL (COUNT (*), 0)
            FROM TR_TEST_QA qa
           WHERE qa.TYPE = 5 AND qa.tr = tr.id)
            max_ball
    FROM tr_pt_order_head h,
         user_list u,
         tr,
         tr_loc l,
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
         AND DECODE (:tr_pt_tn, 0, h.tn, :tr_pt_tn) = h.tn
         AND DECODE (:tr, 0, h.tr, :tr) = h.tr
         AND DECODE (:completed,  1, h.completed,  2, 1,  3, 0) = h.completed
         AND h.ok_primary = 1
         AND u.tn = w.slave
ORDER BY h.dt_start, h.id