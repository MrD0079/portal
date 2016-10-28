/* Formatted on 26/11/2015 10:29:42 AM (QP5 v5.252.13127.32867) */
  SELECT id,
         perc,
         name,
         TO_CHAR (created, 'dd.mm.yyyy hh24:mi:ss') created_t,
         TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu_t
    FROM tasks
   WHERE NVL (perc, 0) < 100
ORDER BY lu DESC