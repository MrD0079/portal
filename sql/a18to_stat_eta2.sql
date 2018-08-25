/* Formatted on 12.08.2018 12:36:46 (QP5 v5.252.13127.32867) */
  SELECT key,
         SUM (VALUE) VALUE,
         SUM (tp_kod_cnt) / SUM (VALUE) * 100 perc_pokr_sto
    FROM (  SELECT tn_rm,
                   h_fio_eta key,
                   AVG (VALUE) VALUE,
                   COUNT (DISTINCT tp_kod_key) tp_kod_cnt
              FROM (:brief)
          GROUP BY tn_rm, h_fio_eta)
GROUP BY key