/* Formatted on 21.11.2014 19:50:50 (QP5 v5.227.12220.39724) */
SELECT ROUND (
          (SELECT NVL (sales, 0) / NVL (sales_prev, 0) * 100
             FROM nets_plan_year
            WHERE YEAR = :YEAR AND plan_type = :plan_type AND id_net = :net),
          2)
  FROM DUAL