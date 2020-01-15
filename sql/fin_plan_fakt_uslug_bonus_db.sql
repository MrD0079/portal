/* Formatted on 12/7/2015 5:32:07  (QP5 v5.252.13127.32867) */
/*  FIX 05.10.2019 for Kiriluk */
SELECT /*NVL (n.bonus_base, 0) bonus_base,*/
       (NVL (n.bonus_base, 0) + NVL (n.bonus_base_ng, 0)) bonus_base,
       (NVL (n.bonus_sum, 0) + NVL (n.bonus_sum_ng, 0)) bonus_sum,
       /*NVL (n.bonus_sum, 0) bonus_sum,*/
       NVL (n.bonus_base_coffee, 0) bonus_base_coffee,
       NVL (n.bonus_sum_coffee, 0) bonus_sum_coffee,
       NVL (n.bonus_base_ng, 0) bonus_base_ng,
       NVL (n.bonus_sum_ng, 0) bonus_sum_ng
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