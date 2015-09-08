/* Formatted on 24.07.2013 14:11:27 (QP5 v5.227.12220.39724) */
  SELECT parent_fio,
         fio,
         y,
         SUM (fact_ball) fact_ball
    FROM (  SELECT MAX (unm.fio) parent_fio,
                   urm.fio fio,
                   c.y,
                   c.q,
                   c.my m,
                     TRUNC (
                          DECODE (
                             SUM (NVL (wm.akb, 0)),
                             0, 0,
                               SUM (NVL (wm.ttqty, 0))
                             / SUM (NVL (wm.akb, 0))
                             * 100)
                        - DECODE (
                             SUM (NVL (wbm.akbprev, 0)),
                             0, 0,
                               SUM (NVL (wbm.ttqtybaseperiod, 0))
                             / SUM (NVL (wbm.akbprev, 0))
                             * 100))
                   * 100
                      fact_ball,
                   v.h_groupname,
                   v.cat,
                   vp.groupname
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
                   parents nm,
                   calendar c
             WHERE     v.m = c.data
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
          GROUP BY urm.fio,
                   c.y,
                   c.q,
                   c.my,
                   v.h_groupname,
                   v.cat,
                   vp.groupname
          ORDER BY MAX (unm.fio),
                   urm.fio,
                   c.y,
                   c.q,
                   c.my)
GROUP BY parent_fio, fio, y