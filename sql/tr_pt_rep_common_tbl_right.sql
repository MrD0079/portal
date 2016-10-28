/* Formatted on 30.07.2013 16:39:57 (QP5 v5.227.12220.39724) */
  SELECT tr.id, tr.name, COUNT (*) cnt
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
         AND u.pos_id IN (:pos)
   and ((:tr_pt_rep_common_datauvol='all') or (:tr_pt_rep_common_datauvol='actual' and nvl(u.datauvol,trunc(sysdate))>=trunc(sysdate)))
GROUP BY tr.id, tr.name
ORDER BY tr.name