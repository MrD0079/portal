/* Formatted on 08.01.2013 15:36:04 (QP5 v5.163.1008.3004) */
  SELECT c.dw,
         TO_CHAR (c.data, 'dd.mm.yyyy') data,
         c.y,
         c.q,
         c.my,
         c.wm,
         c.dy,
         c.dw,
         c.is_wd,
         c.mt,
         c.dwt
    FROM calendar c
   WHERE TRUNC (data, 'mm') = TO_DATE (:sd, 'dd.mm.yyyy') AND wm = :week                                                                                                                /* AND dw <> 7*/
ORDER BY data