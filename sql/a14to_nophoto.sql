/* Formatted on 09.01.2015 17:07:51 (QP5 v5.227.12220.39724) */
  SELECT u1.fio parent_fio,
         u1.tn parent_tn,
         u.tn,
         u.region_name,
         r.tp_place,
         r.tp_type,
         r.stelag,
         r.tumb,
         t.*
    FROM (  SELECT t.tab_num,
                   t.h_fio_eta,
                   t.fio_ts,
                   t.fio_eta,
                   t.tp_kod_key,
                   t.tp_ur,
                   t.tp_addr,
                   SUM (t.visit) visit
              FROM a14to t
             WHERE     t.visitdate BETWEEN TO_DATE (:sd, 'dd.mm.yyyy')
                                       AND TO_DATE (:ed, 'dd.mm.yyyy')
                   AND DECODE (:eta_list, '', t.h_fio_eta, :eta_list) =
                          t.h_fio_eta
            HAVING     SUM (DECODE (url, NULL, 0, 1)) = 0
                   AND CASE
                          WHEN    :ok_visit = 1
                               OR :ok_visit = 2 AND SUM (t.visit) <> 0
                               OR :ok_visit = 3 AND SUM (t.visit) = 0
                          THEN
                             1
                          ELSE
                             0
                       END = 1
          GROUP BY t.tab_num,
                   t.h_fio_eta,
                   t.fio_ts,
                   t.fio_eta,
                   t.tp_kod_key,
                   t.tp_ur,
                   t.tp_addr) t,
         (SELECT DISTINCT tp_place,
                          tp_type,
                          stelag,
                          tumb,
                          tab_number,
                          tp_kod
            FROM routes
           WHERE dpt_id = :dpt_id) r,
         user_list u,
         parents p,
         user_list u1
   WHERE     p.tn = u.tn
         AND p.parent = u1.tn
         AND                       /*r.tab_number = u.tab_num
                               AND */
            u.tab_num = t.tab_num
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
         AND (r.stelag > 0 OR r.tumb > 0)
         AND DECODE (:region_list,
                               '', NVL (u.region_name, '0'),
                               :region_list) = NVL (u.region_name, '0')
ORDER BY u1.fio,
         t.fio_ts,
         t.fio_eta,
         t.tp_ur,
         t.tp_addr,
         r.tp_place,
         t.tp_kod_key