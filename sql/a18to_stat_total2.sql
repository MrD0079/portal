/* Formatted on 10.08.2018 22:03:11 (QP5 v5.252.13127.32867) */
SELECT SUM (VALUE) VALUE,
       /*sum(summa) summa,*/
       DECODE (SUM (VALUE), 0, 0, SUM (tp_kod_cnt) / SUM (VALUE) * 100)
          perc_pokr_sto
  FROM (  SELECT tn_rm,
                 h_fio_eta key,
                 AVG (VALUE) VALUE,
                 /*sum (summa) summa,*/
                 COUNT (DISTINCT tp_kod_key) tp_kod_cnt
            FROM (:brief)
        GROUP BY tn_rm, h_fio_eta)