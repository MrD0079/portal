/* Formatted on 30.09.2015 16:22:44 (QP5 v5.252.13127.32867) */
SELECT COUNT (*)
  FROM MERCH_SPEC_REPORT_PR
 WHERE     dt = TO_DATE ( :dt, 'dd/mm/yyyy')
       AND ag_id = :ag_id
       AND kod_tp = :kod_tp