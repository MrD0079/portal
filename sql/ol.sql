/* Formatted on 03.03.2014 9:54:53 (QP5 v5.227.12220.39724) */
  SELECT ol.*, ol_gr.gr, u.fio, ol_gr.name gr_name
    FROM ol, user_list u, ol_gr
   WHERE     ol.dpt_id = :dpt_id
         AND u.tn = ol.tn
         AND ol.gruppa = ol_gr.id(+)
         AND ol.dpt_id = ol_gr.dpt_id(+)
ORDER BY ol_gr.gr, ol.num, u.fio