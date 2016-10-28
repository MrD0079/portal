/* Formatted on 03/11/2015 16:40:54 (QP5 v5.252.13127.32867) */
  SELECT c.y,
         c.wy,
         TO_CHAR (MIN (c.data), 'dd.mm.yyyy') w_start,
         TO_CHAR (MAX (c.data), 'dd.mm.yyyy') w_end,
         COUNT (*) days,
         CASE
            WHEN TRUNC (MAX (c.data), 'mm') >
                    ADD_MONTHS (TRUNC (SYSDATE, 'mm'), -2)
            THEN
               1
            ELSE
               0
         END
            ms_agenda_enabled,
         CASE
            WHEN TRUNC (MAX (c.data), 'mm') >
                    ADD_MONTHS (TRUNC (SYSDATE, 'mm'), -2)
            THEN
               1
            ELSE
               0
         END
            ms_sku_visit_enabled
    FROM calendar c
GROUP BY c.y, c.wy
ORDER BY c.y, c.wy