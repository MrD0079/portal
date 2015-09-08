  SELECT parent_fio,
         fio,
         y,
         q,
         m,
         SUM (fact_ball) fact_ball,
         DECODE (SUM (bad_akb), 0, 0, 1) bad_akb
    FROM (  
  SELECT unm.fio parent_fio,
         urm.fio fio,
         c.y,
         c.q,
         c.my m,
                   /*DECODE (SIGN (10
                                 - MIN ( (SELECT MIN (NVL (w4u.akb, 0))
                                            FROM w4u
                                           WHERE w4u.data IN (v.m, v.bm) AND w4u.tab_num = v.tab_num))),
                           -1, 0,
                           1)*/ DECODE (SIGN (10
                                 - MIN ( (SELECT MIN (akb)
                                            FROM (  SELECT v_.m,
                                                           v_.bm,
                                                           v_.tab_num,
                                                           v_.h_fio_eta,
                                                           LEAST (NVL (MIN (wm_.akb), 0), NVL (MIN (wbm_.akb), 0)) akb
                                                      FROM w4u wm_,
                                                           w4u_transit wbm_,
                                                           w4u_list v_,
                                                           w4u_prod vp_,
                                                           calendar c_
                                                     WHERE     v_.m = c_.data
                                                           AND wm_.data(+) = v_.m
                                                           AND wbm_.data(+) = v_.bm
                                                           AND wbm_.m(+) = v_.m
                                                           AND wm_.product_id(+) = v_.prod_id
                                                           AND wbm_.product_id(+) = v_.prod_id
                                                           AND wm_.h_fio_eta(+) = v_.h_fio_eta
                                                           AND wbm_.h_fio_eta(+) = v_.h_fio_eta
                                                           AND vp_.product_id = v_.prod_id
                                                           AND (wbm_.visible IS NULL OR wbm_.visible = 1)
                                                  GROUP BY v_.m,
                                                           v_.bm,
                                                           v_.tab_num,
                                                           v_.h_fio_eta) z
                                           WHERE z.m = v.m AND z.bm = v.bm AND z.tab_num = v.tab_num))),
                           -1, 0,
                           1)
                      bad_akb,
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
GROUP BY unm.fio,
         urm.fio,
         c.y,
         c.q,
         c.my,
                   v.prod_id,
                   v.cat,
                   vp.product_name_sw
)
GROUP BY parent_fio,
         fio,
         y,
         q,
         m
ORDER BY parent_fio,
         fio,
         y,
         q,
         m