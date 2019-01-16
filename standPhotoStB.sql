SELECT t.url,
       t.h_url,
       TO_CHAR ( t.visitdate, 'dd.mm.yyyy') visitdate
  FROM a14to t, a14tost s
 WHERE     t.tp_kod_key = :tp_kod
        AND t.visitdate BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy') AND TO_DATE(:ed,'dd.mm.yyyy')
       AND t.url IS NOT NULL
       AND t.h_url = s.h_url(+)
       AND CASE
              WHEN    :ok_ts = 1
                   OR :ok_ts = 2 AND s.h_url IS NOT NULL AND s.ts IS NOT NULL
                                        OR :ok_ts = 3 AND t.h_url IS NOT NULL AND s.ts IS NULL

              THEN
                 1
              ELSE
                 0
           END = 1
       AND CASE
              WHEN    :ok_auditor = 1
                   OR     :ok_auditor = 2
                      AND s.h_url IS NOT NULL
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
                   OR :st_ts = 2 AND s.h_url IS NOT NULL AND s.ts = 1
                   OR :st_ts = 3 AND s.h_url IS NOT NULL AND s.ts = 2
              THEN
                 1
              ELSE
                 0
           END = 1
       AND CASE
              WHEN    :st_auditor = 1
                   OR     :st_auditor = 2
                      AND s.h_url IS NOT NULL
                      AND s.auditor = 1
                   OR     :st_auditor = 3
                      AND s.h_url IS NOT NULL
                      AND s.auditor = 2
              THEN
                 1
              ELSE
                 0
           END = 1