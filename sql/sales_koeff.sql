/* Formatted on 08/10/2015 12:41:44 (QP5 v5.252.13127.32867) */
SELECT ROUND (
          (SELECT DECODE (NVL (sales_prev, 0),
                          0, 0,
                          (NVL (sales, 0) / NVL (sales_prev, 0) - 1) * 100)
             FROM nets_plan_year
            WHERE YEAR = :YEAR AND plan_type = :plan_type AND id_net = :net),
          2)
          percent,
       ROUND (
          (SELECT DECODE (
                     NVL (sales_prev_ng, 0),
                     0, 0,
                     (NVL (sales_ng, 0) / NVL (sales_prev_ng, 0) - 1) * 100)
             FROM nets_plan_year
            WHERE YEAR = :YEAR AND plan_type = :plan_type AND id_net = :net),
          2)
          percent_ng
  FROM DUAL