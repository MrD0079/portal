/* Formatted on 02/09/2016 10:35:22 (QP5 v5.252.13127.32867) */
SELECT SUM (stelag) stelag,
       SUM (tumb) tumb,
       SUM (visit) visit,
       SUM (urls) urls,
       SUM (DECODE (NVL (ts, 0), 1, 1, 0)) ts,
       SUM (DECODE (NVL (auditor, 0), 1, 1, 0)) auditor
  FROM (  SELECT t.fio_ts,
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
                 s.ts ts,
                 s.auditor auditor,
                 TO_CHAR (t.visitdate, 'dd.mm.yyyy') visitdate,
                 TO_CHAR (t.visitdate, 'dd_mm_yyyy') visitdate_key,
                 TO_CHAR (s.auditor_lu, 'dd.mm.yyyy hh24:mi:ss') auditor_lu,
                 s.auditor_fio,
                 s.ts_comm,
                 s.tasks_assort,
                 s.tasks_mr,
                 standart
            FROM a14to t,
                 (SELECT DISTINCT tp_place,
                                  tp_type,
                                  stelag,
                                  tumb,
                                  tab_number,
                                  tp_kod
                    FROM routes
                   WHERE dpt_id = :dpt_id) r,
                 full w,
                 user_list u,
                 a14totp s
           WHERE               /*r.tab_number = u.tab_num
                           AND */
                u    .tab_num = t.tab_num
                 AND u.dpt_id = :dpt_id
                 AND u.tn = w.slave
                 AND w.master = :tn
                 AND t.tp_kod_key = r.tp_kod
                 AND t.visitdate = s.visitdate(+)
                 AND t.tp_kod_key = s.tp_kod(+)
                 /*AND (r.stelag > 0 OR r.tumb > 0)*/
                 AND t.visitdate = TO_DATE ( :dt, 'dd.mm.yyyy')
                 AND ( :eta_list IS NULL OR :eta_list = t.h_fio_eta)
                 AND CASE
                        WHEN    :ok_visit = 1
                             OR :ok_visit = 2 AND t.visit = 1
                             OR :ok_visit = 3 AND t.visit = 0
                        THEN
                           1
                        ELSE
                           0
                     END = 1
                 AND (   :standart = 1
                      OR ( :standart = 2 AND standart = 'A')
                      OR ( :standart = 3 AND standart = 'B'))
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
        GROUP BY t.fio_ts,
                 t.fio_eta,
                 t.tp_kod_key,
                 t.tp_ur,
                 t.tp_addr,
                 r.tp_place,
                 r.tp_type,
                 r.stelag,
                 r.tumb,
                 s.ts,
                 s.auditor,
                 t.visit,
                 t.visitdate,
                 s.auditor_lu,
                 s.auditor_fio,
                 s.ts_comm,
                 s.tasks_assort,
                 s.tasks_mr,
                 standart
        ORDER BY t.fio_ts,
                 t.fio_eta,
                 t.tp_ur,
                 t.tp_addr,
                 r.tp_place,
                 t.tp_kod_key)