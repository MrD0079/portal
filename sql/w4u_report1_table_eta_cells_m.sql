/* Formatted on 21/08/2013 10:24:42 (QP5 v5.227.12220.39724) */
  SELECT MAX (u.fio) parent_fio,
         v.fio_eta fio,
         c.y,
         c.q,
         c.my m,
         DECODE (
              DECODE (SIGN (10 - MAX (NVL (wm.akb, 0))), -1, 1, 0)
            * DECODE (SIGN (10 - MAX (NVL (wbm.akbprev, 0))), -1, 1, 0),
            1, 0,
            1)
            bad_akb,
         SUM (
              CASE
                 WHEN     NVL (wm.ttqty, 0) - NVL (wbm.ttqtybaseperiod, 0) > 0
                      AND NVL (v.min_por, 0) > 0
                      AND DECODE (NVL (wm.akb, 0),
                                  0, 0,
                                  wm.ttqty / NVL (wm.akb, 0) * 100) <
                             NVL (v.min_por, 0)
                 THEN
                    0
                 ELSE
                    NVL (wm.ttqty, 0) - NVL (wbm.ttqtybaseperiod, 0)
              END
            * v.ball)
            fact_ball
    FROM w4u_pg wm,
         (SELECT *
            FROM w4u_transit1
           WHERE visible = 1) wbm,
         w4u_list1 v,
         w4u_lpg vp,
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
GROUP BY v.fio_eta,
         c.y,
         c.q,
         c.my
ORDER BY c.y,
         c.q,
         c.my,
         MAX (u.fio),
         v.fio_eta