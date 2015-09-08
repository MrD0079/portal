/* Formatted on 27/03/2015 11:23:39 (QP5 v5.227.12220.39724) */
  SELECT t.visitdate,
         TO_CHAR (t.visitdate, 'dd.mm.yyyy') vd,
         t.fio_ts,
         t.fio_eta,
         t.tp_kod_key,
         t.tp_ur,
         t.tp_addr,
         r.tp_place,
         r.tp_type,
         r.stelag,
         r.tumb,
         t.visit,
         SUM (DECODE (t.url, NULL, 0, 1)) urls,
         SUM (DECODE (s.ts, 1, 1, 0)) ts1,
         SUM (DECODE (s.auditor, 1, 1, 0)) auditor1,
         SUM (DECODE (t.h_url, NULL, 0, 1) * DECODE (s.ts, NULL, 1, 0)) tsnull,
         SUM (DECODE (t.h_url, NULL, 0, 1) * DECODE (s.auditor, NULL, 1, 0))
            auditornull,
         (    SELECT DECODE (COUNT (*), 0, 0, 1)
                FROM (SELECT master, slave
                        FROM full
                       WHERE full = 1)
               WHERE master = :tn
          START WITH slave = u.tn
          CONNECT BY PRIOR master = slave)
            is_chief,
         u.tn
    FROM a14to t,
         (SELECT DISTINCT tp_place,
                          tp_type,
                          stelag,
                          tumb,
                          tab_number,
                          tp_kod
            FROM routes
           WHERE dpt_id = :dpt_id) r,
         user_list u,
         a14tost s
   WHERE     /*r.tab_number = u.tab_num
         AND */
        u    .tab_num = t.tab_num
         AND u.dpt_id = :dpt_id
         AND u.tn IN
                (SELECT slave
                   FROM full
                  WHERE master =
                           DECODE (:exp_list_without_ts,
                                   0, master,
                                   :exp_list_without_ts))
         AND u.tn IN
                (SELECT slave
                   FROM full
                  WHERE master =
                           DECODE (:exp_list_only_ts,
                                   0, master,
                                   :exp_list_only_ts))
         AND (   u.tn IN
                    (SELECT slave
                       FROM full
                      WHERE master IN
                               (SELECT parent
                                  FROM assist
                                 WHERE child = :tn AND dpt_id = :dpt_id
                                UNION
                                SELECT DECODE (:tn, -1, master, :tn) FROM DUAL))
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_traid_kk, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_kpr, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND t.tp_kod_key = r.tp_kod
         AND t.h_url = s.h_url(+)
         AND (r.stelag > 0 OR r.tumb > 0)
         AND t.visitdate BETWEEN TO_DATE (:sd, 'dd.mm.yyyy')
                             AND TO_DATE (:ed, 'dd.mm.yyyy')
         AND DECODE (:eta_list, '', t.h_fio_eta, :eta_list) = t.h_fio_eta
         AND CASE
                WHEN    :ok_visit = 1
                     OR :ok_visit = 2 AND t.visit = 1
                     OR :ok_visit = 3 AND t.visit = 0
                THEN
                   1
                ELSE
                   0
             END = 1
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
  HAVING CASE
            WHEN    :ok_photo = 1
                 OR :ok_photo = 2 AND SUM (DECODE (t.url, NULL, 0, 1)) > 0
                 OR :ok_photo = 3 AND SUM (DECODE (t.url, NULL, 0, 1)) = 0
            THEN
               1
            ELSE
               0
         END = 1
--and t.tp_ur like '%Голиусов%'
GROUP BY t.visitdate,
         t.fio_ts,
         t.fio_eta,
         t.tp_kod_key,
         t.tp_ur,
         t.tp_addr,
         r.tp_place,
         r.tp_type,
         r.stelag,
         r.tumb,
         t.visit,
         u.tn
ORDER BY t.visitdate,
         t.fio_ts,
         t.fio_eta,
         t.tp_ur,
         t.tp_addr,
         r.tp_place,
         t.tp_kod_key