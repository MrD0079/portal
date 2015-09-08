/* Formatted on 30.07.2013 16:40:25 (QP5 v5.227.12220.39724) */
  SELECT u.pos_id, u.pos_name, COUNT (*) cnt
    FROM tr,
         tr_order_head th,
         tr_order_body tb,
         user_list u
   WHERE     tb.manual >= 0
         AND u.tn = tb.tn
         AND u.dpt_id = :dpt_id
         AND tb.head = th.id
         AND tr.id = th.tr
         AND th.dt_start BETWEEN TO_DATE (:sd, 'dd.mm.yyyy')
                             AND TO_DATE (:ed, 'dd.mm.yyyy')
         AND tr.id IN (:tr)
         AND DECODE (:region_name, '0', '0', :region_name) =
                DECODE (:region_name, '0', '0', u.region_name)
         AND DECODE (:department_name, '0', '0', :department_name) =
                DECODE (:department_name, '0', '0', u.department_name)
GROUP BY u.pos_id, u.pos_name
ORDER BY u.pos_name