/* Formatted on 23/11/2015 2:30:32 PM (QP5 v5.252.13127.32867) */
  SELECT mc.my,
         DECODE (
              DECODE ( :plan_type, 1, 0, NVL (mo.ok_rmkk_tmkk, 0))
            + NVL (mo.ok_dpu, 0),
            0, 0,
            1)
            disabled
    FROM (SELECT DISTINCT my, mt FROM calendar) mc, nets_plan_month_ok mo
   WHERE     mc.my = mo.MONTH(+)
         AND mo.id_net(+) = :net
         AND mo.YEAR(+) = :y
         AND mo.plan_type(+) = :plan_type
ORDER BY mc.my