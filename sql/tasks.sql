/* Formatted on 10/11/2015 11:52:56 (QP5 v5.252.13127.32867) */
  SELECT id,
         perc,
         name,
         TO_CHAR (created, 'dd.mm.yyyy hh24:mi:ss') created_t,
         TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu_t,
		 text
    FROM tasks
ORDER BY lu DESC