/* Formatted on 02/09/2016 10:22:03 (QP5 v5.252.13127.32867) */
SELECT t.url /*,
        t.h_url,
        s.ts,
        s.ts_comm,
        s.auditor_comm,
        s.auditor,
        s.auditor_fio,
        TO_CHAR (s.auditor_lu, 'dd.mm.yyyy hh24:mi:ss') auditor_lu,
        s.tasks_mr,
        s.tasks_assort*/
  FROM a18to t, a18totp s
 WHERE     t.tp_kod_key = :tp_kod
       AND t.visitdate = TO_DATE ( :dt, 'dd.mm.yyyy')
       AND t.url IS NOT NULL
       AND t.visitdate = s.visitdate(+)
       AND t.tp_kod_key = s.tp_kod(+)
       AND CASE
              WHEN    :ok_ts = 1
                   OR     :ok_ts = 2
                      AND s.visitdate IS NOT NULL
                      AND s.ts IS NOT NULL
                   OR :ok_ts = 3 AND t.h_url IS NOT NULL AND s.ts IS NULL
              THEN
                 1
              ELSE
                 0
           END = 1
       AND CASE
              WHEN    :ok_auditor = 1
                   OR     :ok_auditor = 2
                      AND s.visitdate IS NOT NULL
                      AND s.auditor IS NOT NULL
                   OR     :ok_auditor = 3
                      AND t.h_url IS NOT NULL
                      AND s.auditor IS NULL
              THEN
                 1
              ELSE
                 0
           END = 1
       AND CASE
              WHEN    :st_ts = 1
                   OR :st_ts = 2 AND s.visitdate IS NOT NULL AND s.ts = 1
                   OR :st_ts = 3 AND s.visitdate IS NOT NULL AND s.ts = 2
              THEN
                 1
              ELSE
                 0
           END = 1
       AND CASE
              WHEN    :st_auditor = 1
                   OR     :st_auditor = 2
                      AND s.visitdate IS NOT NULL
                      AND s.auditor = 1
                   OR     :st_auditor = 3
                      AND s.visitdate IS NOT NULL
                      AND s.auditor = 2
              THEN
                 1
              ELSE
                 0
           END = 1
       AND (   :type_standart = 1
            OR ( :type_standart = 2 AND type_standart = 'A')
            OR ( :type_standart = 3 AND type_standart = 'B'))