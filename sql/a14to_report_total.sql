/* Formatted on 15/12/2014 13:59:09 (QP5 v5.227.12220.39724) */
SELECT SUM (stelag) stelag,
       SUM (tumb) tumb,
       SUM (visit) visit,
       SUM (urls) urls,
       SUM (ts) ts,
       SUM (auditor) auditor,
       DECODE (NVL (SUM (DECODE (visit, 1, stelag + tumb, 0)), 0),
               0, 0,
               SUM (ts) / SUM (DECODE (visit, 1, stelag + tumb, 0)) * 100)
          perc_ts
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
                 SUM (DECODE (s.ts, 1, 1, 0)) ts,
                 SUM (DECODE (s.auditor, 1, 1, 0)) auditor
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
                 a14tost s
           WHERE     /*r.tab_number = u.tab_num
         AND */ u.tab_num = t.tab_num
                 AND u.dpt_id = :dpt_id
                 AND u.tn = w.slave
                 AND w.master = :tn
                 AND t.tp_kod_key = r.tp_kod
                 AND t.h_url = s.h_url(+)
                 AND (r.stelag > 0 OR r.tumb > 0)
                 AND visitdate = TO_DATE (:dt, 'dd.mm.yyyy')
                 AND (:eta_list is null OR :eta_list = t.h_fio_eta)
                 AND CASE
                        WHEN    :ok_visit = 1
                             OR :ok_visit = 2 AND t.visit = 1
                             OR :ok_visit = 3 AND t.visit = 0
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
        GROUP BY t.fio_ts,
                 t.fio_eta,
                 t.tp_kod_key,
                 t.tp_ur,
                 t.tp_addr,
                 r.tp_place,
                 r.tp_type,
                 r.stelag,
                 r.tumb,
                 t.visit
        ORDER BY t.fio_ts,
                 t.fio_eta,
                 t.tp_ur,
                 t.tp_addr,
                 r.tp_place,
                 t.tp_kod_key)