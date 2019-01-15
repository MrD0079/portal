SELECT t.url, TO_CHAR ( s.visitdate, 'dd.mm.yyyy') visitdate
  FROM a18to t, a18totp s
 WHERE     t.tp_kod_key = :tp_kod
       AND t.visitdate BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy') AND TO_DATE(:ed,'dd.mm.yyyy')
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
              WHEN    :st_ts = 1
                   OR :st_ts = 2 AND s.visitdate IS NOT NULL AND s.ts = 1
                   OR :st_ts = 3 AND s.visitdate IS NOT NULL AND s.ts = 2
              THEN
                 1
              ELSE
                 0
           END = 1