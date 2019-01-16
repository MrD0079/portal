/* Formatted on 16/06/2016 15:58:55 (QP5 v5.252.13127.32867) */
  SELECT fio_rm,
         tn_rm,
         tn_rm key,
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
         tab_num_rm
    FROM (:brief)
GROUP BY fio_rm, tn_rm, tab_num_rm
ORDER BY fio_rm, tn_rm