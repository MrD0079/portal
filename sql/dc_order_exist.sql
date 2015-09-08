/* Formatted on 04.03.2013 10:06:19 (QP5 v5.163.1008.3004) */
SELECT h.*,
       u.fio,
       l.name loc_name,
       TO_CHAR (h.dt_start, 'dd/mm/yyyy') dt_start_t,
       (SELECT COUNT (*)
          FROM dc_order_body
         WHERE head = h.id AND manual >= 0)
          stud_cnt,
       l.url,l.addr,l.text loc_text
  FROM dc_order_head h, user_list u, tr_loc l
 WHERE h.loc = :loc AND h.dt_start = TO_DATE (:dt_start, 'dd/mm/yyyy') AND u.tn = h.tn AND h.loc = l.id