SELECT   fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn,
         wm_concat (DISTINCT region_name) region_name,
         SUM (ts1r) ts1r,
         key,
        COUNT(tp_cnt) tp_cnt,
        sum(visit_plan) visit_plan,
         sum(visit_fakt)
            visit_fakt,
        COUNT(STTOTP) STTOTP,
         tab_num_ts,
         tab_num_tm,
         tab_num_rm,
        SUM(standA) standA,
        SUM(standAmin) standAmin
FROM (
/* Formatted on 16/06/2016 15:58:46 (QP5 v5.252.13127.32867) */
  SELECT fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn,
         tn key,
         SUM (ts1r) ts1r, /* стандарты по визитам */
         wm_concat (DISTINCT region_name) region_name,
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
         --COUNT (DISTINCT DECODE (zst_lu, NULL, NULL, tp_kod_key)) STTOTP,
         COUNT (
            DISTINCT CASE
                        WHEN standart_tp IS NOT NULL OR zst_lu IS NOT NULL /*AND NVL (reject_traid_in_month, 0) = 0*/
                        THEN
                           tp_kod_key
                     END) STTOTP,
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
         tab_num_ts,
         tab_num_tm,
         tab_num_rm
ORDER BY fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn
)GROUP BY fio_rm,
         tn_rm,
         fio_tm,
         tn_tm,
         fio_ts,
         tn,
        key,
         tab_num_ts,
         tab_num_tm,
         tab_num_rm