/* Formatted on 10/11/2015 22:04:00 (QP5 v5.252.13127.32867) */
SELECT id,
       perc,
       name,
       text,
       TO_CHAR (dt_start, 'dd.mm.yyyy') dt_start,
       TO_CHAR (dt_end, 'dd.mm.yyyy') dt_end,
       TO_CHAR (created, 'dd.mm.yyyy hh24:mi:ss') created_t,
       TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu_t
  FROM tasks
 WHERE id = :id