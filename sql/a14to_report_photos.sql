/* Formatted on 24/11/2014 13:42:29 (QP5 v5.227.12220.39724) */
SELECT t.url,
       t.h_url,
       s.ts,
       s.ts_comm,
       s.tasks_assort,
       s.tasks_mr,
       s.auditor
  FROM a14to t, a14tost s
 WHERE     t.tp_kod_key = :tp_kod
       AND t.visitdate = TO_DATE (:dt, 'dd.mm.yyyy')
       AND t.url IS NOT NULL
       AND t.h_url = s.h_url(+)