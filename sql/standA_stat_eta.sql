SELECT   fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn,
         wm_concat (DISTINCT region_name) region_name,
         fio_eta,
         SUM (ts1r) ts1r,
         key,
        COUNT(tp_cnt) tp_cnt,
        sum(visit_plan) visit_plan,
         sum(visit_fakt)
            visit_fakt,
        COUNT(STTOTP) STTOTP,
        eta_tab_number,
         tab_num_ts,
         tab_num_tm,
         tab_num_rm,
        SUM(standA) standA,
        SUM(standAmin) standAmin
FROM (
  SELECT fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn,
         wm_concat (DISTINCT region_name) region_name,
         fio_eta,
         SUM (ts1r) ts1r, /* стандарты по визитам */
         h_fio_eta key,
         COUNT (DISTINCT tp_kod_key) tp_cnt,
         sum(visitdate)/*COUNT (DISTINCT tp_kod_key || visitdate)*/ visit_plan,
         sum(visit)/*   COUNT (DISTINCT DECODE (visit, 0, NULL, tp_kod_key || visitdate))*/
            visit_fakt,
         DECODE (
            sum(visitdate)/*COUNT (DISTINCT tp_kod_key || visitdate)*/,
            0, 0,
              sum(visit)/*   COUNT (DISTINCT DECODE (visit, 0, NULL, tp_kod_key || visitdate))*/
            / sum(visitdate)/*COUNT (DISTINCT tp_kod_key || visitdate)*/
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
         tab_num_rm,
        SUM(standA) standA,
        SUM(standAmin) standAmin
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
)GROUP BY fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn,
         fio_eta,
        key,
          eta_tab_number,
         tab_num_ts,
         tab_num_tm,
         tab_num_rm