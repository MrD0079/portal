/* Formatted on 27.07.2012 13:07:34 (QP5 v5.163.1008.3004) */
  SELECT z.*,
         TO_CHAR (lu, 'dd/mm/yyyy hh24:mi:ss') lu_t,
         SUBSTR (REGEXP_REPLACE (text, '<[^>]+>', ''), 0, 100) || '...' text_ss
    FROM news_eta z
where dpt_id=:dpt_id
ORDER BY lu DESC