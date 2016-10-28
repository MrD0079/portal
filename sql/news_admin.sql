/* Formatted on 10/11/2015 11:31:40 (QP5 v5.252.13127.32867) */
  SELECT z.*,
         TO_CHAR (lu, 'dd/mm/yyyy hh24:mi:ss') lu_t,
         SUBSTR (REGEXP_REPLACE (text, '<[^>]+>', ''), 0, 100) || '...' text_ss
    FROM news z
   WHERE dpt_id = :dpt_id
ORDER BY lu DESC