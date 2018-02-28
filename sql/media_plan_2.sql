/* Formatted on 20.02.2018 12:47:20 (QP5 v5.252.13127.32867) */
  SELECT m.*,
         TO_CHAR (dt_start, 'dd.mm.yyyy') dt_start,
         TO_CHAR (dt_end, 'dd.mm.yyyy') dt_end
    FROM media_plan_2 m
   WHERE     dt_start BETWEEN TO_DATE ( :dates_list1, 'dd.mm.yyyy')
                          AND TO_DATE ( :dates_list2, 'dd.mm.yyyy')
         AND DECODE ( :id_net, 0, 0, :id_net) = DECODE ( :id_net, 0, 0, id_net)
ORDER BY m.act,
         m.creator,
         m.dt_start,
         m.dt_end