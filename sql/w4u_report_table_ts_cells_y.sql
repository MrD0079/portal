/* Formatted on 27.03.2013 8:27:03 (QP5 v5.163.1008.3004) */
  SELECT parent_fio,
         fio,
         y,
         SUM (fact_ball) fact_ball
    FROM (  SELECT utm.fio parent_fio,
                   u.fio fio,
                   c.y,
                   c.q,
                   c.my m,
                   TRUNC (DECODE (SUM (NVL (wm.akb, 0)), 0, 0, SUM (wm.qtytt) / SUM (NVL (wm.akb, 0)) * 100) - DECODE (SUM (NVL (wbm.akb, 0)), 0, 0, SUM (wbm.qtytt) / SUM (NVL (wbm.akb, 0)) * 100)) * 100
                      fact_ball,
                   v.prod_id,
                   v.cat,
                   vp.product_name_sw
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
          GROUP BY utm.fio,
                   u.fio,
                   c.y,
                   c.q,
                   c.my,
                   v.prod_id,
                   v.cat,
                   vp.product_name_sw
          ORDER BY utm.fio,
                   u.fio,
                   c.y,
                   c.q,
                   c.my)
GROUP BY parent_fio, fio, y