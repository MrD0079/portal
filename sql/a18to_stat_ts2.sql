/* Formatted on 1/15/2016 12:31:41  (QP5 v5.252.13127.32867) */
  SELECT key,
         SUM (VALUE) VALUE,
         SUM (tp_kod_cnt) / SUM (VALUE) * 100 perc_pokr_sto
    FROM (  SELECT tn key, SUM (VALUE) VALUE, SUM (tp_kod_cnt) tp_kod_cnt
              FROM (  SELECT tn,
                             h_fio_eta key,
                             AVG (VALUE) VALUE,
                             COUNT (DISTINCT tp_kod_key) tp_kod_cnt
                        FROM (:brief)
                    GROUP BY h_fio_eta, tn)
          GROUP BY tn)
GROUP BY key