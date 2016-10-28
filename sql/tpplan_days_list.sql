/* Formatted on 05/11/2015 17:20:59 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT dw_num, dw_text
    FROM routes
   WHERE dw_num IS NOT NULL
ORDER BY dw_num