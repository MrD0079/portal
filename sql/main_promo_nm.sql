/* Formatted on 20.01.2017 16:35:10 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT c.mt || ' ' || c.y dt, c.y, c.my
    FROM promo_nm k, calendar c
   WHERE     NVL (k.oknm_fm, 0) = 1
         AND NVL (k.oknm_nm, 0) = 0
         AND c.y = k.year
         AND c.my = k.month
         AND k.tn = :tn
ORDER BY c.y, c.my