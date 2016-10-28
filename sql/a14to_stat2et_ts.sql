/* Formatted on 16/06/2016 15:58:46 (QP5 v5.252.13127.32867) */
  SELECT fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn,
         tn key,
         wm_concat (DISTINCT region_name) region_name,
         COUNT (DISTINCT tp_kod_key) tp_cnt,
         COUNT (DISTINCT tp_kod_key || visitdate) visit_plan,
         COUNT (DISTINCT DECODE (visit, 0, NULL, tp_kod_key || visitdate))
            visit_fakt,
         DECODE (
            COUNT (DISTINCT tp_kod_key || visitdate),
            0, 0,
              COUNT (DISTINCT DECODE (urls, 0, NULL, tp_kod_key || visitdate))
            / COUNT (DISTINCT tp_kod_key || visitdate)
            * 100)
            perc_photo_rep,
         COUNT (DISTINCT DECODE (zst_lu, NULL, NULL, tp_kod_key)) STTOTP,
         tab_num_ts,
         tab_num_tm,
         tab_num_rm
    FROM (SELECT z.*,
                 CASE
                    WHEN :by_who = 'eta' THEN standart_price_eta
                    WHEN :by_who = 'ts' THEN standart_price_ts
                 END
                    standart_price
            FROM a14to_mv z
           WHERE     visitdate BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                   AND TO_DATE ( :ed, 'dd.mm.yyyy')
                 AND (   :exp_list_without_ts = 0
                      OR tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_without_ts))
                 AND (   :exp_list_only_ts = 0
                      OR tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_only_ts))
                 AND (   tn IN (SELECT slave
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
                 AND dpt_id = :dpt_id
                 AND (:eta_list is null OR :eta_list = h_fio_eta)
                 AND DECODE ( :ok_ts, 1, ok_ts, :ok_ts) = ok_ts
                 AND DECODE ( :ok_auditor, 1, ok_auditor, :ok_auditor) =
                        ok_auditor
                 AND DECODE ( :st_ts, 1, st_ts, :st_ts) = st_ts
                 AND DECODE ( :st_auditor, 1, st_auditor, :st_auditor) =
                        st_auditor
                 AND DECODE ( :ok_st_tm, 1, ok_st_tm, :ok_st_tm) = ok_st_tm
                       AND (   :standart = 1
                            OR ( :standart = 2 AND standart = 'A')
                            OR ( :standart = 3 AND standart = 'B')))
GROUP BY fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn,
         tab_num_ts,
         tab_num_tm,
         tab_num_rm
ORDER BY fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn