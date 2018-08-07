/* Formatted on 05/08/2018 18:11:41 (QP5 v5.252.13127.32867) */
  SELECT t.fio_ts,
         t.fio_eta,
         t.tp_kod_key,
         t.tp_ur,
         t.tp_addr,
         r.tp_place,
         r.tp_type,
         t.visit,
         t.urls,
         TO_CHAR (t.visitdate, 'dd.mm.yyyy') visitdate,
         TO_CHAR (t.visitdate, 'dd_mm_yyyy') visitdate_key,
         t.target,
         t.target_info
    FROM a18to_visits t,
         (SELECT DISTINCT tp_place,
                          tp_type,
                          tab_number,
                          tp_kod
            FROM routes
           WHERE dpt_id = :dpt_id) r,
         full w,
         user_list u
   WHERE     u.tab_num = t.tab_num
         AND u.dpt_id = :dpt_id
         AND u.tn = w.slave
         AND w.master = :tn
         AND t.tp_kod_key = r.tp_kod
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
         AND CASE
                WHEN    :ok_photo = 1
                     OR :ok_photo = 2 AND t.urls > 0
                     OR :ok_photo = 3 AND t.urls = 0
                THEN
                   1
                ELSE
                   0
             END = 1
ORDER BY t.fio_ts,
         t.fio_eta,
         t.tp_ur,
         t.tp_addr,
         r.tp_place,
         t.tp_kod_key