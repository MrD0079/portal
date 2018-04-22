/* Formatted on 16.04.2018 10:20:59 (QP5 v5.252.13127.32867) */
SELECT DISTINCT r.rep_id,
                r.name,
                r.pict,
                TO_CHAR (r.text) text,
                CASE WHEN s.lu IS NULL THEN 'red' ELSE 'green' END color,
                r.aa_id
  FROM MERCH_REPORT_CAL_REMINDERS r, MERCH_REPORT_CAL_SOK s
 WHERE     r.ag_id = :ag_id
       AND r.head_id = :route
       AND r.kodtp = :kodtp
       AND r.data = TO_DATE ( :dates_list, 'dd/mm/yyyy')
       AND r.ag_id = s.ag_id(+)
       AND r.head_id = s.head_id(+)
       AND r.kodtp = s.kodtp(+)
       AND r.data = s.data(+)
       AND r.rep_id = s.rep_id(+)
       AND r.aa_id = s.aa_id(+)
       AND r.rep_id = 6
UNION
SELECT DISTINCT r.rep_id,
                r.name,
                r.pict,
                TO_CHAR (r.text) text,
                CASE WHEN s.lu IS NULL THEN 'red' ELSE 'green' END color,
                r.aa_id
  FROM MERCH_REPORT_CAL_REMINDERS r, MERCH_REPORT_CAL_SOK s
 WHERE     r.ag_id = :ag_id
       AND r.head_id = :route
       AND r.kodtp = :kodtp
       AND r.data = TO_DATE ( :dates_list, 'dd/mm/yyyy')
       AND r.ag_id = s.ag_id(+)
       AND r.head_id = s.head_id(+)
       AND r.kodtp = s.kodtp(+)
       AND r.data = s.data(+)
       AND r.rep_id = s.rep_id(+)
       AND r.rep_id <> 6
ORDER BY pict