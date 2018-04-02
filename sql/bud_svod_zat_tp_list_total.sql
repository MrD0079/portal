/* Formatted on 24.03.2018 09:25:37 (QP5 v5.252.13127.32867) */
SELECT COUNT (*) c,
       COUNT (DISTINCT tp_kod) tpc,
       SUM (summa) summa,
       SUM (skidka_val) skidka_val,
       SUM (total) total,
       SUM (act_bonus) act_bonus,
       SUM (act_local_bonus) act_local_bonus,
       SUM (zay_zat) zay_zat,
       SUM (zat_total) zat_total,
       DECODE (NVL (SUM (summa), 0),
               0, 0,
               (SUM (zat_total)) / SUM (summa) * 100)
          zat_perc
  FROM (:sql)