/* Formatted on 14/10/2014 10:06:00 (QP5 v5.227.12220.39724) */
  SELECT c.*, NVL (d.id, FN_GET_NEW_ID) id, d.day
    FROM (SELECT DISTINCT dw, dwtc FROM calendar) c,
         (SELECT *
            FROM ms_sendmaster_days
           WHERE parent = :parent) d
   WHERE c.dw = d.day(+)
ORDER BY c.dw