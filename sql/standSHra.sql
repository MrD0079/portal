/* Formatted on 15.06.2017 09:37:44 (QP5 v5.252.13127.32867) */
  SELECT TO_CHAR (t.visitdate, 'dd.mm.yyyy') vd,
         t.fio_ts,
         t.fio_eta,
         t.tp_kod_key,
         t.tp,
         r.tp_type_short,
         SUM (DECODE (t.url, NULL, 0, 1)) urls,
           DECODE (SUM (DECODE (t.h_url, NULL, 0, 1)), 0, 0, 1)
         * DECODE (s.ts, NULL, 1, 0)
            tsnull,
           DECODE (SUM (DECODE (t.h_url, NULL, 0, 1)), 0, 0, 1)
         * DECODE (s.tm, NULL, 1, 0)
            tmnull,
         (    SELECT DECODE (COUNT (*), 0, 0, 1)
                FROM (SELECT master, slave
                        FROM full
                       WHERE full = 1)
               WHERE master = :tn
          START WITH slave = u.tn
          CONNECT BY PRIOR master = slave)
            is_chief,
         u.tn,
         NVL (s.ts, 0) ts,
         NVL (s.tm, 0) tm,
         TO_CHAR (t.visitdate, 'dd.mm.yyyy') visitdate,
         TO_CHAR (t.visitdate, 'dd_mm_yyyy') visitdate_key,
         TO_CHAR (s.tm_lu, 'dd.mm.yyyy hh24:mi:ss') tm_lu,
         s.tm_fio,
         s.ts_comm,
         s.tasks_assort,
         s.tasks_mr,
         s.tm_comm,
         s.traid_comm,
         s.traid,
         t.target,
         t.target_info
    FROM standSH t,
         (SELECT DISTINCT tp_place,
                          tp_type,
                          tp_type_short,
                          stelag,
                          tumb,
                          tab_number,
                          tp_kod
            FROM routes
           WHERE dpt_id = :dpt_id) r,
         user_list u,
         standSHtp s,
         standSHurl url
   WHERE     u.tab_num = t.tab_num
         AND u.dpt_id = :dpt_id
    and u.is_spd=1
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
         AND t.tp_kod_key = r.tp_kod
         AND t.visitdate = s.visitdate(+)
         AND t.tp_kod_key = s.tp_kod(+)
         AND t.visitdate BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                             AND TO_DATE ( :ed, 'dd.mm.yyyy')
         AND ( :eta_list IS NULL OR :eta_list = t.h_fio_eta)
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
GROUP BY t.visitdate,
         t.fio_ts,
         t.fio_eta,
         t.tp_kod_key,
         t.tp,
         r.tp_type_short,
         u.tn,
         s.ts,
         s.tm,
         s.tm_lu,
         s.tm_fio,
         s.ts_comm,
         s.tasks_assort,
         s.tasks_mr,
         s.tm_comm,
         s.traid_comm,
         s.traid,
         t.target,
         t.target_info
ORDER BY t.tp_kod_key,
         t.visitdate,
         t.fio_ts,
         t.fio_eta,
         t.tp