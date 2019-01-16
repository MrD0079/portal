/* Formatted on 10.08.2018 09:53:30 (QP5 v5.252.13127.32867) */
SELECT COUNT (DISTINCT tp_kod_key) tp_cnt,
        SUM (ts1r) ts1r,
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
       sum(visitdate)/*COUNT (DISTINCT tp_kod_key || visitdate)*/ / SUM (VALUE) * 100
          perc_pokr_sto,
       /*COUNT (DISTINCT DECODE (zst_lu, NULL, NULL, tp_kod_key)) STTOTP*/
       COUNT (DISTINCT CASE WHEN standart_tp IS NOT NULL OR zst_lu IS NOT NULL /*AND NVL (reject_traid_in_month, 0) = 0*/
                       THEN tp_kod_key END) STTOTP
  FROM (:brief)