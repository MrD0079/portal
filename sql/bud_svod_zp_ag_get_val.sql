/* Formatted on 17.05.2018 16:30:37 (QP5 v5.252.13127.32867) */
SELECT sv.h_eta,
       sv.fio,
       NVL (vp.val_fact, 0) val_fact,
       vp.val_plan dz_return,
       s.per_zp * sv.sales dz_return_norm,
       s.per_zp * 100 sales_perc,
       DECODE (NVL (vp.val_plan, 0),
               0, 0,
               (NVL (vp.val_fact, 0)) / vp.val_plan * 100)
          plan_perc,
       sv.fal_payment,
       s.per_zp * sv.sales zp_plan,
       sv.zp_fakt,
       sv.probeg,
       sv.gbo,
       sv.amort,
       DECODE (NVL (sv.fal_payment, 0), 0, 0, sv.amort / sv.fal_payment * 100)
          amort_perc,
       NVL (sv.fal_payment, 0) + NVL (sv.amort, 0) + NVL (sv.gbo_warmup, 0)
          total1,
       sv.fil,
       sv.sales
  FROM (  SELECT m.dt,
                 m.tab_num,
                 m.h_eta,
                 m.eta,
                 m.eta_tab_number,
                 SUM (m.summa) summa,
                 SUM (m.coffee) coffee,
                 eta_coffee,
                 per_zp/100 per_zp
            FROM a14mega m
           WHERE m.dpt_id = :dpt_id
        GROUP BY m.dt,
                 m.tab_num,
                 m.h_eta,
                 m.eta,
                 m.eta_tab_number,
                 m.eta_coffee,
                 m.per_zp) s,
       user_list u,
       bud_svod_zp sv,
       (SELECT n1.norm,
               n1.dt,
               n1.fund,
               f1.kod
          FROM bud_funds_norm n1, bud_funds f1
         WHERE n1.fund = f1.id AND f1.dpt_id = :dpt_id) n,
       (SELECT h_eta,
               (NVL (val_plan, 0)) * 1000 val_plan,
               (NVL (val_fact, 0)) * 1000 val_fact,
               k.dt
          FROM kpr k
         WHERE k.dpt_id = :dpt_id) vp
 WHERE     sv.id = :id
       AND sv.dt(+) = s.dt
       AND sv.dt = n.dt(+)
       AND sv.dt = vp.dt(+)
       AND sv.h_eta = vp.h_eta(+)
       AND n.kod(+) = 'zp'
       AND s.h_eta = sv.h_eta(+)
       AND s.tab_num = u.tab_num
       AND u.dpt_id = :dpt_id