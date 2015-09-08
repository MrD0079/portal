/* Formatted on 18.03.2013 15:51:35 (QP5 v5.163.1008.3004) */
  SELECT v.fio_eta fio,
         v.h_fio_eta tn,
         SUM (wm.akb) m_akb,
         SUM (wbm.akb) bm_akb,
         SUM (wm.qtytt) m_qtytt,
         SUM (wbm.qtytt) bm_qtytt,
         DECODE (SUM (wm.akb), 0, 0, SUM (wm.qtytt) / SUM (wm.akb) * 100) perc,
         DECODE (SUM (wbm.akb), 0, 0, SUM (wbm.qtytt) / SUM (wbm.akb) * 100) bperc,
         sum(CASE
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
GROUP BY v.fio_eta, v.h_fio_eta
ORDER BY v.fio_eta, v.h_fio_eta