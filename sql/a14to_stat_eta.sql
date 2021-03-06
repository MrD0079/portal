/* Formatted on 12/02/2015 11:03:29 (QP5 v5.227.12220.39724) */
  SELECT parent_fio,
         parent_tn,
         parent_tn tn_tm,
         parent_fio fio_tm,
         fio_ts,
         tn,
         wm_concat (distinct region_name) region_name,
         fio_eta,
         COUNT(ts1r) ts1r,
         h_fio_eta key,
         COUNT (DISTINCT tp_kod_key || visitdate) tp_cnt,
         COUNT (DISTINCT DECODE (visit, 0, NULL, tp_kod_key || visitdate))
            visit_cnt,
          eta_tab_number,
          tab_num_ts
    FROM (  SELECT u1.fio parent_fio,
                   u1.tn parent_tn,
                   u1.tab_num tab_num_ts,
                   u.tn,
                   r.eta_tab_number,
                   u.region_name,
                   t.h_fio_eta,
                   t.visitdate,
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
                   SUM(CASE WHEN DECODE(NVL(s.ts, 0), 1, 1, 0) = 1 AND s.auditor <> 2
                      THEN 1
                      ELSE 0
                    END)
                   ts1r,
                   SUM (DECODE (s.auditor, 1, 1, 0)) auditor1,
                   SUM (DECODE (t.h_url, NULL, 0, 1) * DECODE (s.ts, NULL, 1, 0))
                      tsnull,
                   SUM (
                        DECODE (t.h_url, NULL, 0, 1)
                      * DECODE (s.auditor, NULL, 1, 0))
                      auditornull,
                   AVG (sp.VALUE) VALUE

              FROM a14to t,
                   (SELECT DISTINCT tp_place,
                                    tp_type,
                                    stelag,
                                    tumb,
                                    tab_number,
                                    tp_kod,
                                    ETA_TAB_NUMBER
                      FROM routes
                      WHERE dpt_id = :dpt_id) r,
                   user_list u,
                   a14tost s,
                   parents p,
                   user_list u1,
                   (  SELECT data, h_fio_eta, AVG (VALUE) VALUE
                        FROM a14tosp
                       WHERE data BETWEEN TRUNC (TO_DATE (:sd, 'dd.mm.yyyy'), 'mm')
                                      AND TRUNC (TO_DATE (:ed, 'dd.mm.yyyy'), 'mm')
                    GROUP BY data, h_fio_eta) sp
                   /* ,(SELECT dpt_id,
                       tp_kod,
                       dt,
                       summa,
                       coffee,
                       eta_tab_number
                      FROM a14mega) m*/
                      /*user_list utm*/
             WHERE     p.tn = u.tn
                  /* AND ptm.parent = utm.tn
                   AND ptm.tn = u.tn */
                   /*AND u.dpt_id = m.dpt_id
                   AND TRUNC(t.visitdate, 'mm') = m.dt (+)
                   AND t.tp_kod_key = m.tp_kod (+)*/
                   AND t.h_fio_eta = sp.h_fio_eta(+)
                   AND TRUNC (t.visitdate, 'mm') = sp.data(+)
                   AND p.parent = u1.tn
                   AND             /*r.tab_number = u.tab_num
                               AND */
                      u.tab_num = t.tab_num
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
                   AND (   u.tn IN
                              (SELECT slave
                                 FROM full
                                WHERE master IN
                                         (SELECT parent
                                            FROM assist
                                           WHERE child = :tn AND dpt_id = :dpt_id
                                          UNION
                                          SELECT DECODE (:tn, -1, master, :tn)
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
                   AND t.h_url = s.h_url(+)
                   AND (r.stelag > 0 OR r.tumb > 0)
                   AND t.visitdate BETWEEN TO_DATE (:sd, 'dd.mm.yyyy')
                                       AND TO_DATE (:ed, 'dd.mm.yyyy')
                   AND (:eta_list is null OR :eta_list = t.h_fio_eta)
                   AND DECODE (:region_list,
                               '', NVL (u.region_name, '0'),
                               :region_list) = NVL (u.region_name, '0')
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
                               OR     :ok_ts = 2
                                  AND s.h_url IS NOT NULL
                                  AND s.ts IS NOT NULL
                               OR     :ok_ts = 3
                                  AND t.h_url IS NOT NULL
                                  AND s.ts IS NULL
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
                           OR     :ok_photo = 2
                              AND SUM (DECODE (t.url, NULL, 0, 1)) > 0
                           OR     :ok_photo = 3
                              AND SUM (DECODE (t.url, NULL, 0, 1)) = 0
                      THEN
                         1
                      ELSE
                         0
                   END = 1
          GROUP BY u1.fio,
                   u1.tn,
                   u1.tab_num,
                   u.tn,
                   u.region_name,
                   t.h_fio_eta,
                   t.visitdate,
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
                   r.eta_tab_number

          ORDER BY t.visitdate,
                   t.fio_ts,
                   u.tn,
                   t.fio_eta,
                   t.tp_ur,
                   t.tp_addr,
                   r.tp_place,
                   t.tp_kod_key)
GROUP BY parent_fio,
         parent_tn,
         fio_ts,
         tn,
         fio_eta,
         h_fio_eta,
         eta_tab_number,
         tab_num_ts
ORDER BY parent_fio,
         parent_tn,
         fio_ts,
         tn,
         fio_eta