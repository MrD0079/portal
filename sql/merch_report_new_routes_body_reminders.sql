/* Formatted on 19/08/2015 15:29:36 (QP5 v5.227.12220.39724) */
  SELECT r.rep_id,
         r.name,
         r.pict,
         r.text,
         CASE
            WHEN r.rep_id IN (2, 6)
            THEN
               'yellow'
            WHEN r.rep_id IN (1, 3, 4, 5)
            THEN
               CASE WHEN s.lu IS NULL THEN 'red' ELSE 'green' END
         END
            color
    FROM MERCH_REPORT_CAL_REMINDERS r, MERCH_REPORT_CAL_SOK s
   WHERE     r.ag_id = :ag_id
         AND r.head_id = :route
         AND r.kodtp = :kodtp
         AND r.data = TO_DATE (:dates_list, 'dd/mm/yyyy')
         AND r.ag_id = s.ag_id(+)
         AND r.head_id = s.head_id(+)
         AND r.kodtp = s.kodtp(+)
         AND r.data = s.data(+)
ORDER BY r.pict