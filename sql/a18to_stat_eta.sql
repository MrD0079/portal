/* Formatted on 10.08.2018 10:02:21 (QP5 v5.252.13127.32867) */
  SELECT fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn,
         wm_concat (DISTINCT region_name) region_name,
         fio_eta,
         h_fio_eta key,
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
         /*COUNT (DISTINCT DECODE (zst_lu, NULL, NULL, tp_kod_key)) STTOTP,*/
         COUNT (
            DISTINCT CASE
                        WHEN standart_tp IS NOT NULL OR zst_lu IS NOT NULL /*AND NVL (reject_traid_in_month, 0) = 0*/
                        THEN
                           tp_kod_key
                     END)
            STTOTP,
         eta_tab_number,
         tab_num_ts,
         tab_num_tm,
         tab_num_rm
    FROM (:brief)
GROUP BY fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn,
         fio_eta,
         h_fio_eta,
         eta_tab_number,
         tab_num_ts,
         tab_num_tm,
         tab_num_rm