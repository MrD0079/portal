/* Formatted on 26.03.2013 15:38:27 (QP5 v5.163.1008.3004) */
  SELECT u.fio parent_fio,
         v.fio_eta fio,
         c.y,
         SUM (
            CASE
               WHEN NVL (wm.qtytt, 0) - NVL (wbm.qtytt, 0) > 0 AND NVL (v.min_por, 0) > 0 AND DECODE (NVL (wm.akb, 0), 0, 0, wm.qtytt / NVL (wm.akb, 0) * 100) < NVL (v.min_por, 0) THEN 0
               ELSE NVL (wm.qtytt, 0) - NVL (wbm.qtytt, 0)
            END
            * v.ball)
            fact_ball
    FROM w4u wm,
         (select * from w4u_transit) wbm,
         w4u_list v,
         w4u_prod vp,
         user_list u,
         user_list utm,
         user_list urm,
         user_list unm,
         parents ts,
         parents tm,
         parents rm,
         parents nm,
         calendar c
   WHERE     v.m = c.data
         AND wm.data(+) = v.m
         AND wbm.data(+) = v.bm AND wbm.m(+) = v.m
         AND wm.product_id(+) = v.prod_id
         AND wbm.product_id(+) = v.prod_id
         AND wm.h_fio_eta(+) = v.h_fio_eta
         AND wbm.h_fio_eta(+) = v.h_fio_eta
         AND vp.product_id = v.prod_id
         AND u.dpt_id = :dpt_id
         AND u.pos_id = 57
         AND u.tab_num = v.tab_num
         AND u.tn = ts.tn
         AND utm.tn = tm.tn
         AND urm.tn = rm.tn
         AND unm.tn = nm.tn
         AND ts.parent = tm.tn
         AND tm.parent = rm.tn
         AND rm.parent = nm.tn
         and (wbm.visible is null or wbm.visible=1)
GROUP BY u.fio, v.fio_eta, c.y
ORDER BY u.fio, v.fio_eta, c.y