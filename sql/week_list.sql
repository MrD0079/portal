/* Formatted on 06/07/2015 13:06:41 (QP5 v5.227.12220.39724) */
  SELECT c.y,
         c.wy,
         TO_CHAR (MIN (c.data), 'dd.mm.yyyy') w_start,
         TO_CHAR (MAX (c.data), 'dd.mm.yyyy') w_end,
         COUNT (*) days,
         CASE
            WHEN MIN (c.data) > ADD_MONTHS (TRUNC (SYSDATE, 'mm'), -2) THEN 1
            ELSE 0
         END
            ms_agenda_enabled,
         CASE
            WHEN MIN (c.data) > ADD_MONTHS (TRUNC (SYSDATE, 'mm'), -2) THEN 1
            ELSE 0
         END
            ms_sku_visit_enabled
    FROM calendar c
GROUP BY c.y, c.wy
ORDER BY c.y, c.wy