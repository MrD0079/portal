/* Formatted on 30.09.2015 15:44:31 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT r.rep_id,
                  r.name,
                  r.pict,
                  r.text,
                  CASE
                     WHEN r.rep_id IN (6            /* Акционная активность */
                                        )
                     THEN
                        'yellow'
                     WHEN r.rep_id IN (1                            /* Фото */
                                        ,
                                       2                             /* OOS */
                                        ,
                                       3                         /* Остатки */
                                        ,
                                       4               /* Количество фейсов */
                                        ,
                                       5                            /* Цена */
                                        )
                     THEN
                        CASE WHEN s.lu IS NULL THEN 'red' ELSE 'green' END
                  END
                     color
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
ORDER BY r.pict