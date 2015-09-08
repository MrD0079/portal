/* Formatted on 12/03/2014 15:09:47 (QP5 v5.227.12220.39724) */
  SELECT c.*, x.*, TO_CHAR (c.data, 'dd.mm.yyyy') dt_t
    FROM (  SELECT h.dt, COUNT (b.tp) c
              FROM beg_routes_head h, beg_routes_body b
             WHERE     h.id = b.head_id
                   AND tn = :tn
                   AND TRUNC (h.dt, 'mm') =
                          TRUNC (TO_DATE (:dt, 'dd.mm.yyyy'), 'mm')
            HAVING COUNT (b.tp) > 0
          GROUP BY h.dt) x,
         calendar c
   WHERE     x.dt(+) = c.data
         AND TRUNC (c.data, 'mm') = TRUNC (TO_DATE (:dt, 'dd.mm.yyyy'), 'mm')
ORDER BY c.data