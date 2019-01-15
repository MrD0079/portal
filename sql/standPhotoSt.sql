SELECT t.url, t.h_url, TO_CHAR ( s.visitdate, 'dd.mm.yyyy') visitdate
FROM :standT t, :standTtp s, :standTurl url
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
              WHEN    :ok_tm = 1
                   OR     :ok_tm = 2
                      AND s.visitdate IS NOT NULL
                      AND s.tm IS NOT NULL
                   OR :ok_tm = 3 AND t.h_url IS NOT NULL AND s.tm IS NULL
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
              WHEN    :st_tm = 1
                   OR :st_tm = 2 AND s.visitdate IS NOT NULL AND s.tm = 1
                   OR :st_tm = 3 AND s.visitdate IS NOT NULL AND s.tm = 2
              THEN
                 1
              ELSE
                 0
           END = 1
       AND t.h_url = url.h_url(+)
       AND (   url.h_url IS NOT NULL
            OR (SELECT NVL (is_ts, 0)
                  FROM user_list
                 WHERE tn = :tn) = 1)