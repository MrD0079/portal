/* Formatted on 24.07.2013 16:18:14 (QP5 v5.227.12220.39724) */
  SELECT u.tn,
         u.fio,
         SUM (NVL (wm.ttqty, 0)) m_qtytt,
         SUM (NVL (wbm.ttqtybaseperiod, 0)) bm_qtytt,
         SUM (NVL (wm.akb, 0)) m_akb,
         SUM (NVL (wbm.akbprev, 0)) bm_akb,
         v.H_GROUPNAME prod_id,
         v.m,
         v.bm,
         v.ball,
         v.min_por,
         DECODE (SUM (NVL (wm.akb, 0)),
                 0, 0,
                 SUM (wm.ttqty) / SUM (NVL (wm.akb, 0)) * 100)
            perc,
         DECODE (SUM (NVL (wbm.akbprev, 0)),
                 0, 0,
                 SUM (wbm.ttqtybaseperiod) / SUM (NVL (wbm.akbprev, 0)) * 100)
            bperc,
           TRUNC (
                DECODE (SUM (NVL (wm.akb, 0)),
                        0, 0,
                        SUM (wm.ttqty) / SUM (NVL (wm.akb, 0)) * 100)
              - DECODE (
                   SUM (NVL (wbm.akbprev, 0)),
                   0, 0,
                   SUM (wbm.ttqtybaseperiod) / SUM (NVL (wbm.akbprev, 0)) * 100))
         * 100
            fact_ball,
         v.cat,
         vp.groupname product_name_sw
    FROM w4u_pg wm,
         (SELECT *
            FROM w4u_transit1
           WHERE visible = 1) wbm,
         w4u_list1 v,
         w4u_list3 v2,
         w4u_lpg vp,
         user_list u,
         user_list utm,
         user_list urm,
         user_list unm,
         parents ts,
         parents tm,
         parents rm,
         parents nm
   WHERE     v.m = TO_DATE (:dt, 'dd.mm.yyyy')
         AND v.tab_num = v2.tab_num(+)
         AND v.m = v2.m(+)
         AND v.bm = v2.bm(+)
         AND wm.dt(+) = v.m
         AND wbm.dt(+) = v.bm
         AND wbm.m(+) = v.m
         AND wm.H_GROUPNAME(+) = v.H_GROUPNAME
         AND wbm.H_GROUPNAME(+) = v.H_GROUPNAME
         AND wm.h_fio_eta(+) = v.h_fio_eta
         AND wbm.h_fio_eta(+) = v.h_fio_eta
         AND vp.H_GROUPNAME = v.H_GROUPNAME
         AND vp.dt = v.m
         AND u.dpt_id = :dpt_id
         AND (   u.tn IN
                    (SELECT slave
                       FROM full
                      WHERE master =
                               DECODE (
                                  :w4u_process_ts_list,
                                  0, DECODE (
                                        :w4u_process_tm_list,
                                        0, DECODE (:w4u_process_rm_list,
                                                   0, :tn,
                                                   :w4u_process_rm_list),
                                        :w4u_process_tm_list),
                                  :w4u_process_ts_list))
              OR (SELECT NVL (is_super, 0) + NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn =
                            DECODE (
                               :w4u_process_ts_list,
                               0, DECODE (
                                     :w4u_process_tm_list,
                                     0, DECODE (:w4u_process_rm_list,
                                                0, :tn,
                                                :w4u_process_rm_list),
                                     :w4u_process_tm_list),
                               :w4u_process_ts_list)) > 0)
         AND u.pos_id = 57
         AND u.tab_num = v.tab_num
         AND u.tn = ts.tn
         AND utm.tn = tm.tn
         AND urm.tn = rm.tn
         AND unm.tn = nm.tn
         AND ts.parent = tm.tn
         AND tm.parent = rm.tn
         AND rm.parent = nm.tn
         AND (wbm.visible IS NULL OR wbm.visible = 1)
GROUP BY u.tn,
         u.fio,
         v.H_GROUPNAME,
         v.m,
         v.bm,
         v.ball,
         v.min_por,
         v.cat,
         vp.groupname
ORDER BY v.cat, vp.groupname, u.fio