/* Formatted on 18/05/2015 19:28:10 (QP5 v5.227.12220.39724) */
SELECT sv.h_eta,
       sv.fio,
       sv.dz_return,
       sv.dz_return * n.norm / 100 dz_return_norm,
       sv.dz_return * 0.003 dz_return_norm03,
       DECODE (NVL (sv.sales, 0),
               0, 0,
               sv.dz_return * n.norm / 100 / sv.sales * 100)
          sales_perc,
       sv.akb_penalty,
       sv.fal_payment,
       sv.dz_return * n.norm / 100 - NVL (sv.akb_penalty, 0) zp_plan,
       sv.zp_fakt,
       sv.probeg,
       sv.gbo,
       sv.amort,
       DECODE (NVL (sv.fal_payment, 0),
               0, 0,
               sv.amort / sv.fal_payment * 100)
          amort_perc,
       NVL (sv.fal_payment, 0) + NVL (sv.amort, 0) + NVL (sv.gbo_warmup, 0)
          total1,
       sv.fil,
       sv.sales
  FROM bud_svod_zp sv,
       (SELECT n1.norm,
               n1.dt,
               n1.fund,
               f1.kod
          FROM bud_funds_norm n1, bud_funds f1
         WHERE n1.fund = f1.id AND f1.dpt_id = :dpt_id) n
 WHERE sv.id = :id AND sv.dt = n.dt(+) AND n.kod(+) = 'zp'