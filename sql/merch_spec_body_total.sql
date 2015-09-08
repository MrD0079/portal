/* Formatted on 07.06.2012 9:58:23 (QP5 v5.163.1008.3004) */
  SELECT COUNT (*) COUNT, SUM (weight) weight
    FROM merch_spec_body
   WHERE head_id = :head_id
ORDER BY sort