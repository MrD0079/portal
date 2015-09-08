/* Formatted on 18.04.2013 16:40:39 (QP5 v5.163.1008.3004) */
  SELECT w.groupname,
         w.h_groupname,
         vp.id,
         vp.ball,
         vp.min_por,
         vp.cat
    FROM w4u_lpg w, w4u_vp1 vp
   WHERE vp.m(+) = w.dt AND w.H_GROUPNAME = vp.H_GROUPNAME(+) AND w.dt = TO_DATE (:ml1, 'dd.mm.yyyy')
ORDER BY w.GROUPNAME, w.H_GROUPNAME