/* Formatted on 20/11/2014 14:08:10 (QP5 v5.227.12220.39724) */
  SELECT mc.my,
         DECODE (
            NVL (mo.ok_rmkk_tmkk, 0) + NVL (mo.ok_nmkk, 0) + NVL (mo.ok_dpu, 0),
            0, 0,
            1)
            disabled
    FROM (SELECT DISTINCT my, mt FROM calendar) mc, nets_plan_month_ok mo
   WHERE     mc.my = mo.MONTH(+)
         AND mo.id_net(+) = :net
         AND mo.YEAR(+) = :y
         AND mo.plan_type(+) = :plan_type
ORDER BY mc.my