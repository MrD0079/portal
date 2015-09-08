/* Formatted on 12.02.2013 16:50:46 (QP5 v5.163.1008.3004) */
SELECT id,
       rep_tm,
       text,
       count_byu,
       stock_start,
       stock_finish,
       stock_shelf
  FROM atd_tz_ag_report
 WHERE tz_id = :tz_id AND dt = TO_DATE (:dt, 'dd.mm.yyyy')