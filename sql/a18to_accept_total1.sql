/* Formatted on 15.08.2018 22:51:01 (QP5 v5.252.13127.32867) */
SELECT SUM (cto) cto,
       SUM (DECODE (ts, NULL, 1, 0)) tsnull,
       SUM (DECODE (auditor, NULL, 1, 0)) auditornull,
       SUM (DECODE (NVL (ts, 0), 1, 1, 0)) ts,
       SUM (DECODE (NVL (auditor, 0), 1, 1, 0)) auditor
  FROM (  SELECT t.visit,
                 t.visitdate,
                 t.tp_kod_key,
                 t.name_to,
                 t.h_name_to,
                 s.ts,
                 s.auditor,
                 s.traid,
                 COUNT (DISTINCT NVL (t.name_to, 'null')) cto
            FROM a18to t, a18totp s, user_list u,
                  (SELECT DISTINCT tp_place,
                            tp_type,
                            tp_type_short,
                            tab_number,
                            tp_kod
                  FROM routes
                 WHERE dpt_id = :dpt_id) r
           WHERE     u.tab_num = t.tab_num
                 AND t.tab_num = r.tab_number /* fix row */
                 AND t.tp_kod_key = r.tp_kod(+) /* fix row */
                 AND u.dpt_id = :dpt_id
                 AND u.is_spd = 1
                 AND (   :exp_list_without_ts = 0
                      OR u.tn IN (SELECT slave
                                    FROM full
                                   WHERE master = :exp_list_without_ts))
                 AND (   :exp_list_only_ts = 0
                      OR u.tn IN (SELECT slave
                                    FROM full
                                   WHERE master = :exp_list_only_ts))
                 AND (   u.tn IN (SELECT slave
                                    FROM full
                                   WHERE master IN (SELECT parent
                                                      FROM assist
                                                     WHERE     child = :tn
                                                           AND dpt_id = :dpt_id
                                                    UNION
                                                    SELECT DECODE ( :tn,
                                                                   -1, master,
                                                                   :tn)
                                                      FROM DUAL))
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
                 AND ( :eta_list IS NULL OR :eta_list = t.h_fio_eta)
                 AND t.visitdate BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                     AND TO_DATE ( :ed, 'dd.mm.yyyy')
                 AND t.visitdate = s.visitdate(+)
                 AND t.tp_kod_key = s.tp_kod(+)
                 AND t.h_name_to = s.h_name_to(+)
                 AND CASE
                        WHEN    :ok_ts = 1
                             OR (    :ok_ts = 2
                                 AND s.visitdate IS NOT NULL
                                 AND s.ts IS NOT NULL)
                             OR ( :ok_ts = 3 AND s.ts IS NULL)
                        THEN
                           1
                        ELSE
                           0
                     END = 1
                 AND CASE
                        WHEN    :ok_auditor = 1
                             OR (    :ok_auditor = 2
                                 AND s.visitdate IS NOT NULL
                                 AND s.auditor IS NOT NULL)
                             OR ( :ok_auditor = 3 AND s.auditor IS NULL)
                        THEN
                           1
                        ELSE
                           0
                     END = 1
                 AND CASE
                        WHEN    :st_ts = 1
                             OR (    :st_ts = 2
                                 AND s.visitdate IS NOT NULL
                                 AND s.ts = 1)
                             OR (    :st_ts = 3
                                 AND s.visitdate IS NOT NULL
                                 AND s.ts = 2)
                        THEN
                           1
                        ELSE
                           0
                     END = 1
                 AND CASE
                        WHEN    :st_auditor = 1
                             OR (    :st_auditor = 2
                                 AND s.visitdate IS NOT NULL
                                 AND s.auditor = 1)
                             OR (    :st_auditor = 3
                                 AND s.visitdate IS NOT NULL
                                 AND s.auditor = 2)
                        THEN
                           1
                        ELSE
                           0
                     END = 1
        GROUP BY t.visit,
                 t.visitdate,
                 t.tp_kod_key,
                 t.name_to,
                 t.h_name_to,
                 s.ts,
                 s.auditor,
                 s.traid)