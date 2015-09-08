/* Formatted on 24/02/2015 17:37:21 (QP5 v5.227.12220.39724) */
SELECT sv.h_eta,
       sv.fio,
       sv.fal_payment,
       sv.probeg,
       sv.gbo,
       sv.amort,
       DECODE (NVL (sv.fal_payment, 0),
               0, 0,
               sv.amort / sv.fal_payment * 100)
          amort_perc,
       nvl(sv.fal_payment,0) + nvl(sv.amort,0) + nvl(sv.gbo_warmup,0) total1,
       sv.fil,
       sv.sales,
       DECODE (NVL (sv.sales, 0),
               0, 0,
               (nvl(sv.fal_payment,0) + nvl(sv.amort,0) + nvl(sv.gbo_warmup,0)) / sv.sales * 100)
          perc_zat
  FROM bud_svod_zp sv
 WHERE sv.id = :id