/* Formatted on 17.09.2013 12:34:50 (QP5 v5.227.12220.39724) */
SELECT COUNT (*) cnt
  FROM tr,
       tr_pt_order_head th,
       tr_pt_order_body tb,
       user_list u
 WHERE     tb.manual >= 0
       AND u.h_eta = tb.h_eta
       AND u.dpt_id = :dpt_id
       AND tb.head = th.id
       AND tr.id = th.tr
       AND th.dt_start BETWEEN TO_DATE (:sd, 'dd.mm.yyyy')
                           AND TO_DATE (:ed, 'dd.mm.yyyy')
       AND tr.id IN (:tr)
       AND u.pos_id IN (:pos)