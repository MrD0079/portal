/* Formatted on 27.06.2013 9:49:49 (QP5 v5.227.12220.39724) */
SELECT h.*,
       u.fio,
       tr.name,
       l.name loc_name,
       TO_CHAR (h.dt_start, 'dd/mm/yyyy') dt_start_t,
       TO_CHAR (h.completed_lu, 'dd/mm/yyyy hh24:mi:ss') completed_lu,
       (SELECT COUNT (*)
          FROM tr_order_body
         WHERE head = h.id AND manual >= 0)
          stud_cnt,
       u.e_mail,
       TO_CHAR (SYSDATE + 2, 'dd/mm/yyyy hh24:mi') warn48,
       TO_CHAR (h.dt_start + tr.days - 1, 'dd/mm/yyyy') tr_end,
       tr.days,
       tr.days - 1 nights,
       l.url,
       tr.test_len,
       ROUND (tr.test_len / 60) test_len_h,
       (SELECT NVL (COUNT (*), 0)
          FROM tr_test_qa qa
         WHERE qa.TYPE = 5 AND qa.tr = tr.id)
          max_ball,
       l.text loc_text,
       h.dt_start - TRUNC (SYSDATE) days2tr
  FROM tr_order_head h,
       user_list u,
       tr,
       tr_loc l
 WHERE h.id = :id AND u.tn = h.tn AND tr.id = h.tr AND h.loc = l.id