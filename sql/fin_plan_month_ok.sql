/* Formatted on 20/11/2014 14:07:53 (QP5 v5.227.12220.39724) */
  SELECT mc.my,
         mc.mt,
         mo.ok_rmkk_tmkk,
         mo.ok_dpu,
         mo.ok_fm
    FROM (SELECT DISTINCT my, mt FROM calendar) mc, nets_plan_month_ok mo
   WHERE     mc.my = mo.MONTH(+)
         AND mo.id_net(+) = :net
         AND mo.YEAR(+) = :y
         AND mo.plan_type(+) = :plan_type
ORDER BY mc.my