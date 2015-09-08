/* Formatted on 25.01.2014 17:29:33 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT c.dm, c.dwt, TO_CHAR (c.data, 'dd.mm.yyyy') data
    FROM routes_head h, routes_body1 b, calendar c
   WHERE     h.id = :route
         AND b.head_id = h.id
         AND H.DATA = TRUNC (c.data, 'mm')
         AND c.dm = b.day_num
ORDER BY TO_CHAR (c.data, 'dd.mm.yyyy')