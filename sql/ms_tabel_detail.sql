/* Formatted on 01/09/2014 17:24:51 (QP5 v5.227.12220.39724) */
  SELECT c.*, t.hours
    FROM calendar c, ms_tabel_days t, routes_head h
   WHERE     TRUNC (c.data, 'mm') = h.data
         AND h.id = :head_id
         AND c.dm = t.day_num(+)
         AND t.head_id(+) = :head_id
ORDER BY c.data