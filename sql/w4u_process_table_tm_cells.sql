/* Formatted on 18.03.2013 15:31:11 (QP5 v5.163.1008.3004) */
  SELECT u.tn,
         u.fio,
         sum(NVL (wm.qtytt, 0)) m_qtytt,
         sum(NVL (wbm.qtytt, 0)) bm_qtytt,
         sum(NVL (wm.akb, 0)) m_akb,
         sum(NVL (wbm.akb, 0)) bm_akb,
         v.prod_id,
         v.m,
         v.bm,
         v.ball,
         v.min_por,
         DECODE (sum(NVL (wm.akb, 0)), 0, 0, sum(wm.qtytt) / sum(NVL (wm.akb, 0)) * 100) perc,
         DECODE (sum(NVL (wbm.akb, 0)), 0, 0, sum(wbm.qtytt) / sum(NVL (wbm.akb, 0)) * 100) bperc,
         TRUNC (DECODE (SUM (NVL (wm.akb, 0)), 0, 0, SUM (wm.qtytt) / SUM (NVL (wm.akb, 0)) * 100) - DECODE (SUM (NVL (wbm.akb, 0)), 0, 0, SUM (wbm.qtytt) / SUM (NVL (wbm.akb, 0)) * 100)) * 100
         /*SUM (
            TRUNC (
               CASE
                  WHEN NVL (wm.qtytt, 0) - NVL (wbm.qtytt, 0) > 0 AND NVL (v.min_por, 0) > 0 AND TRUNC (DECODE (NVL (wm.akb, 0), 0, 0, wm.qtytt / NVL (wm.akb, 0) * 100)) < NVL (v.min_por, 0) THEN 0
                  ELSE DECODE (NVL (wm.akb, 0), 0, 0, wm.qtytt / NVL (wm.akb, 0) * 100) - DECODE (NVL (wbm.akb, 0), 0, 0, wbm.qtytt / NVL (wbm.akb, 0) * 100)
               END))
         * 100*/
            fact_ball,
         v.cat,
         vp.product_name_sw,
         vp.Product_weight
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
GROUP BY u.tn,
         u.fio,
         v.prod_id,
         v.m,
         v.bm,
         v.ball,
         v.min_por,
         v.cat,
         vp.product_name_sw,
         vp.Product_weight
ORDER BY v.cat, vp.product_name_sw, u.fio