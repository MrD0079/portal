/* Formatted on 11.09.2013 15:21:01 (QP5 v5.227.12220.39724) */
SELECT h.*,
       u.fio,
       tr.name,
       l.name loc_name,
       TO_CHAR (h.dt_start, 'dd/mm/yyyy') dt_start_t,
       (SELECT COUNT (*)
          FROM tr_pt_order_body
         WHERE head = h.id AND manual >= 0)
          stud_cnt
  FROM tr_pt_order_head h,
       user_list u,
       tr,
       tr_loc l
 WHERE     h.loc = :loc
       AND h.dt_start = TO_DATE (:dt_start, 'dd/mm/yyyy')
       AND u.tn = h.tn
       AND tr.id = h.tr
       AND h.loc = l.id