/* Formatted on 08/04/2015 15:03:20 (QP5 v5.227.12220.39724) */
  SELECT f.name,
         n.dt,
         n.norm,
         c.y || ' ' || c.mt period
    FROM bud_funds f, bud_funds_norm n, calendar c
   WHERE     f.id = n.fund
         AND n.dt BETWEEN ADD_MONTHS (TRUNC (SYSDATE, 'mm'), -2)
                      AND TRUNC (SYSDATE, 'mm')
         AND f.dpt_id = :dpt_id
         AND n.dt = c.data
ORDER BY f.name, n.dt