/* Formatted on 21/08/2014 17:53:26 (QP5 v5.227.12220.39724) */
SELECT DECODE (ROUND (ROWNUM / 2) * 2, ROWNUM, 1, 0) color, z.*
  FROM (  SELECT *
            FROM statya
           WHERE     PARENT = :groupp
                 AND DECODE (
                        :edit_statya,
                        0, ID,
                        (SELECT statya
                           FROM nets_plan_month m
                          WHERE     m.ID = :edit_statya
                                AND m.plan_type = :plan_type)) = ID
        ORDER BY cost_item) z