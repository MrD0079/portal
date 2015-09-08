/* Formatted on 30.07.2013 16:39:57 (QP5 v5.227.12220.39724) */
  SELECT tr.id, tr.name, COUNT (*) cnt
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
         AND u.pos_id IN (:pos)
         AND DECODE (:region_name, '0', '0', :region_name) =
                DECODE (:region_name, '0', '0', u.region_name)
         AND DECODE (:department_name, '0', '0', :department_name) =
                DECODE (:department_name, '0', '0', u.department_name)
GROUP BY tr.id, tr.name
ORDER BY tr.name