/* Formatted on 20/11/2014 14:05:31 (QP5 v5.227.12220.39724) */
SELECT n.ok_rmkk_tmkk, n.ok_nmkk, n.ok_dpu
  FROM (SELECT *
          FROM nets_plan_month_ok
         WHERE     id_net = :net
               AND YEAR = :y
               AND MONTH = :m
               AND plan_type = :plan_type) n,
       (SELECT DISTINCT y, my
          FROM calendar
         WHERE y = :y AND my = :m) c
 WHERE n.YEAR(+) = c.y AND n.MONTH(+) = c.my