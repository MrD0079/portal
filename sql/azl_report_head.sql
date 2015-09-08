/* Formatted on 11.02.2013 14:05:59 (QP5 v5.163.1008.3004) */
SELECT id,rep_tm,text
  FROM azl_tz_report
 WHERE tz_id = :tz_id AND dt = to_date(:dt,'dd.mm.yyyy')