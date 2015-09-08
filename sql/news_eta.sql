/* Formatted on 27.07.2012 12:33:47 (QP5 v5.163.1008.3004) */
  SELECT z.*,to_char(lu,'dd/mm/yyyy hh24:mi') lu_t
    FROM news_eta z
where dpt_id=:dpt_id
ORDER BY lu DESC