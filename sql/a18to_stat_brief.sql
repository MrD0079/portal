/* Formatted on 10.08.2018 22:02:10 (QP5 v5.252.13127.32867) */
  SELECT fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn,
         tp_kod_key,
         region_name,
         fio_eta,
         h_fio_eta,
         eta_tab_number,
         tab_num_ts,
         tab_num_tm,
         tab_num_rm,
         visitdate,
         sum(urls) urls,
         sum(cto) cto,
         zst_lu,
         visit,
         VALUE,
         summa,
         SUM (ts1r) ts1r,
         CASE
            WHEN wm_concat (DISTINCT NVL (standart_tp, 'null')) =
                    'Стандарт А'
            THEN
               'Стандарт А'
            WHEN wm_concat (DISTINCT NVL (standart_tp, 'null')) =
                    'Стандарт А (минимум)'
            THEN
               'Стандарт А (минимум)'
         END
            standart_tp
    FROM (SELECT z.*
            FROM a18to_mv z
           WHERE     visitdate BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                   AND TO_DATE ( :ed, 'dd.mm.yyyy')
                 AND (   :exp_list_without_ts = 0
                      OR tn IN (SELECT slave
                                  FROM FULL
                                 WHERE MASTER = :exp_list_without_ts))
                 AND (   :exp_list_only_ts = 0
                      OR tn IN (SELECT slave
                                  FROM FULL
                                 WHERE MASTER = :exp_list_only_ts))
                 AND (   tn IN (SELECT slave
                                  FROM FULL
                                 WHERE MASTER IN (SELECT PARENT
                                                    FROM assist
                                                   WHERE     CHILD = :tn
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
                 AND dpt_id = :dpt_id
                 AND ( :eta_list IS NULL OR :eta_list = h_fio_eta) /*AND DECODE ( :ok_ts, 1, ok_ts, :ok_ts) = ok_ts
                                                                   AND DECODE ( :ok_auditor, 1, ok_auditor, :ok_auditor) =
                                                                          ok_auditor
                                                                   AND DECODE ( :st_ts, 1, st_ts, :st_ts) = st_ts
                                                                   AND DECODE ( :st_auditor, 1, st_auditor, :st_auditor) =
                                                                          st_auditor
                                                                   AND DECODE ( :ok_st_tm, 1, ok_st_tm, :ok_st_tm) = ok_st_tm*/
                                                                   /*AND (   :zst = 1
                                                                        OR ( :zst = 2 AND DECODE (zst_lu, NULL, 0, 1) = 1))*/
         )
GROUP BY fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn,
         tp_kod_key,
         region_name,
         fio_eta,
         h_fio_eta,
         eta_tab_number,
         tab_num_ts,
         tab_num_tm,
         tab_num_rm,
         visitdate,
         /*urls,*/
         /*cto,*/
         zst_lu,
         visit,
         VALUE,
         summa
  HAVING (   :zst = 1
          OR (    :zst = 2
              AND CASE
                     WHEN wm_concat (DISTINCT NVL (standart_tp, 'null')) =
                             'Стандарт А'
                     THEN
                        'Стандарт А'
                     WHEN wm_concat (DISTINCT NVL (standart_tp, 'null')) =
                             'Стандарт А (минимум)'
                     THEN
                        'Стандарт А (минимум)'
                  END
                     IS NOT NULL))