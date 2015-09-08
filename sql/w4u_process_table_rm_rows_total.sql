
  SELECT tn, fio, SUM (fact_ball) fact_ball
    FROM (
  SELECT tm.tn, utm.fio,
         SUM (wm.akb) m_akb,
         SUM (wbm.akb) bm_akb,
         SUM (wm.qtytt) m_qtytt,
         SUM (wbm.qtytt) bm_qtytt,
         DECODE (SUM (wm.akb), 0, 0, SUM (wm.qtytt) / SUM (wm.akb) * 100) perc,
         DECODE (SUM (wbm.akb), 0, 0, SUM (wbm.qtytt) / SUM (wbm.akb) * 100) bperc,
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
         parents nm
   WHERE     v.m = TO_DATE (:dt, 'dd.mm.yyyy')
         AND wm.data(+) = v.m
         AND wbm.data(+) = v.bm AND wbm.m(+) = v.m
         AND wm.product_id(+) = v.prod_id
         AND wbm.product_id(+) = v.prod_id
         AND wm.h_fio_eta(+) = v.h_fio_eta
         AND wbm.h_fio_eta(+) = v.h_fio_eta
         AND vp.product_id = v.prod_id
         AND u.dpt_id = :dpt_id
         AND (u.tn IN
                 (SELECT slave
                    FROM full
                   WHERE master =
                            DECODE (:w4u_process_ts_list, 0, DECODE (:w4u_process_tm_list, 0, DECODE (:w4u_process_rm_list, 0, :tn, :w4u_process_rm_list), :w4u_process_tm_list), :w4u_process_ts_list))
              OR (SELECT NVL (is_super, 0) + NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = DECODE (:w4u_process_ts_list, 0, DECODE (:w4u_process_tm_list, 0, DECODE (:w4u_process_rm_list, 0, :tn, :w4u_process_rm_list), :w4u_process_tm_list), :w4u_process_ts_list)) >
                    0)
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
          GROUP BY tm.tn,
                   utm.fio,
                   v.prod_id,
                   v.cat,
                   vp.product_name_sw)
GROUP BY tn, fio
ORDER BY fio