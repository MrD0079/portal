/* Formatted on 12.02.2013 13:46:35 (QP5 v5.163.1008.3004) */
  SELECT *
    FROM akr_ag_files
   WHERE tz = :tz_id AND dt = TO_DATE (:dt, 'dd.mm.yyyy')
ORDER BY id