/* Formatted on 06.12.2016 15:15:22 (QP5 v5.252.13127.32867) */
SELECT sv.h_eta,
       sv.fio,
       NVL (vp.val_fact, 0) val_fact,
       vp.val_plan dz_return,
         CASE
            WHEN s.eta_coffee = 1
            THEN
               0.03
            WHEN DECODE (NVL (vp.val_plan, 0),
                         0, 0,
                         (NVL (vp.val_fact, 0)) / vp.val_plan * 100) < 80
            THEN
               0.01
            ELSE
               0.02
         END
       * sv.sales
          dz_return_norm,
         CASE
            WHEN s.eta_coffee = 1
            THEN
               0.03
            WHEN DECODE (NVL (vp.val_plan, 0),
                         0, 0,
                         (NVL (vp.val_fact, 0)) / vp.val_plan * 100) < 80
            THEN
               0.01
            ELSE
               0.02
         END
       * 100
          sales_perc,
       DECODE (NVL (vp.val_plan, 0),
               0, 0,
               (NVL (vp.val_fact, 0)) / vp.val_plan * 100)
          plan_perc,
       sv.fal_payment,
         CASE
            WHEN s.eta_coffee = 1
            THEN
               0.03
            WHEN DECODE (NVL (vp.val_plan, 0),
                         0, 0,
                         (NVL (vp.val_fact, 0)) / vp.val_plan * 100) < 80
            THEN
               0.01
            ELSE
               0.02
         END
       * sv.sales
          zp_plan,
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
  FROM (  SELECT m.dt,
                 m.tab_num,
                 m.h_eta,
                 m.eta,
                 m.eta_tab_number,
                 SUM (m.summa) summa,
                 SUM (m.coffee) coffee,
                 eta_coffee
            FROM a14mega m
           WHERE m.dpt_id = :dpt_id
        GROUP BY m.dt,
                 m.tab_num,
                 m.h_eta,
                 m.eta,
                 m.eta_tab_number,
                 eta_coffee) s,
       user_list u,
       bud_svod_zp sv,
       (SELECT n1.norm,
               n1.dt,
               n1.fund,
               f1.kod
          FROM bud_funds_norm n1, bud_funds f1
         WHERE n1.fund = f1.id AND f1.dpt_id = :dpt_id) n,
       (SELECT h_eta,
               (NVL (val_plan, 0) /*+ NVL (coffee_plan, 0)*/) * 1000 val_plan,
               (NVL (val_fact, 0) /*+ NVL (coffee_fact, 0)*/) * 1000 val_fact,
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