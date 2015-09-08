/* Formatted on 09/04/2015 17:44:12 (QP5 v5.227.12220.39724) */
SELECT NVL (sv.summa_return, 0) summa_return,
       NVL (sv.summa_return, 0) * t.bonus / 100 bonus_tp,
       NVL (sv.fixed_fakt, 0) fixed_fakt,
       NVL (sv.bonus_fakt, 0) + NVL (sv.fixed_fakt, 0) total,
       DECODE (
          NVL (s.summa, 0),
          0, 0,
          (NVL (sv.bonus_fakt, 0) + NVL (sv.fixed_fakt, 0)) / s.summa * 100)
          zat,
       sv.ok_db_tn,
       sv.ok_db_fio,
       TO_CHAR (sv.ok_db_lu, 'dd.mm.yyyy hh24:mi:ss') ok_db_lu,
         NVL (sv.fixed_fakt, 0)
       + NVL (sv.summa_return, 0) * t.bonus / 100
          maxtp,
         (NVL (sv.bonus_fakt, 0) + NVL (sv.fixed_fakt, 0))
       * CASE
            WHEN NVL (sv.cash, 0) = 1
            THEN
               1
            ELSE
                 (  1
                  -   NVL (
                         (SELECT discount
                            FROM bud_fil_discount_body
                           WHERE     dt = TO_DATE (:dt, 'dd.mm.yyyy')
                                 AND distr = zp.fil),
                         0)
                    / 100)
               * (SELECT bonus_log_koef
                    FROM bud_fil
                   WHERE id = zp.fil)
         END
          compens_distr
  FROM (SELECT m.tab_num,
               m.tp_kod,
               m.y,
               m.m,
               m.summa,
               m.h_eta,
               m.eta,
               m.skidka,
               m.bedt_summ,
               m.tp_type,
               m.tp_ur,
               m.tp_addr
          FROM a14mega m
         WHERE m.dpt_id = :dpt_id AND TO_DATE (:dt, 'dd.mm.yyyy') = m.dt) s,
       user_list u,
       sc_tp t,
       sc_svod sv,
       (SELECT fil, h_eta
          FROM bud_svod_zp
         WHERE     dt = TO_DATE (:dt, 'dd.mm.yyyy')
               AND dpt_id = :dpt_id
               AND fil IS NOT NULL) zp
 WHERE     s.tab_num = u.tab_num
       AND u.dpt_id = :dpt_id
       AND :dpt_id = t.dpt_id(+)
       AND s.tp_kod = t.tp_kod(+)
       AND s.tp_kod = sv.tp_kod(+)
       AND sv.dt(+) = TO_DATE (:dt, 'dd.mm.yyyy')
       AND :dpt_id = sv.dpt_id(+)
       AND (discount > 0 OR bonus > 0 OR fixed > 0 OR margin > 0)
       AND s.tp_kod = :tp_kod
       AND zp.h_eta = s.h_eta