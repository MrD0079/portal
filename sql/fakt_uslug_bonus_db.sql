/* Formatted on 2012/02/07 20:51 (Formatter Plus v4.8.8) */
SELECT NVL(n.bonus_base, 0) bonus_base,
       NVL(n.bonus_sum, 0) bonus_sum
  FROM (SELECT *
          FROM nets_plan_month_ok
         WHERE id_net = :net
           AND YEAR = :y
           AND MONTH = :m
           AND plan_type = :plan_type) n,
       (SELECT DISTINCT y,
                        my
                   FROM calendar
                  WHERE y = :y
                    AND my = :m) c
 WHERE n.YEAR(+) = c.y
   AND n.MONTH(+) = c.my