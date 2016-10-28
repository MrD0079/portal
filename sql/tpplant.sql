/* Formatted on 17/11/2015 11:09:06 (QP5 v5.252.13127.32867) */
SELECT SUM (summa) summa,
       SUM (summa1) summa1,
       SUM (summa2) summa2,
       SUM (summa3) summa3,
       SUM (summa_avg) summa_avg,
       SUM (plan) plan,
       DECODE (SUM (plan), 0, 0, SUM (summa) / SUM (plan) * 100) perc,
       SUM (shortfall) shortfall
  FROM (/* Formatted on 20/11/2015 7:31:53 PM (QP5 v5.252.13127.32867) */
  SELECT r1.ts,
         r1.eta,
         r1.tp_kod,
         r1.tp_name,
         r1.address,
         r1.tp_place,
         r1.tp_type,
         r1.summa,
         r1.summa1,
         r1.summa2,
         r1.summa3,
         (NVL (r1.summa1, 0) + NVL (r1.summa2, 0) + NVL (r1.summa3, 0)) / 3
            summa_avg,
         p.plan,
         p.rc,
         DECODE (NVL (p.plan, 0), 0, 0, r1.summa / p.plan * 100) perc,
         CASE
            WHEN NVL (p.plan, 0) - NVL (r1.summa, 0) > 0
            THEN
               NVL (p.plan, 0) - NVL (r1.summa, 0)
         END
            shortfall,
         r1.skidka,
         t.discount,
         t.bonus
    FROM (  SELECT r.ts,
                   r.eta,
                   r.h_eta,
                   r.tp_kod,
                   r.tp_name,
                   r.address,
                   r.tp_place,
                   r.tp_type,
                   r.tab_number,
                   MAX (
                      CASE
                         WHEN m.dt = TO_DATE ( :dt, 'dd.mm.yyyy') THEN m.skidka
                      END)
                      skidka,
                   MAX (
                      CASE
                         WHEN m.dt = TO_DATE ( :dt, 'dd.mm.yyyy') THEN m.summa
                      END)
                      summa,
                   MAX (
                      CASE
                         WHEN m.dt =
                                 ADD_MONTHS (TO_DATE ( :dt, 'dd.mm.yyyy'), -1)
                         THEN
                            m.summa
                      END)
                      summa1,
                   MAX (
                      CASE
                         WHEN m.dt =
                                 ADD_MONTHS (TO_DATE ( :dt, 'dd.mm.yyyy'), -2)
                         THEN
                            m.summa
                      END)
                      summa2,
                   MAX (
                      CASE
                         WHEN m.dt =
                                 ADD_MONTHS (TO_DATE ( :dt, 'dd.mm.yyyy'), -3)
                         THEN
                            m.summa
                      END)
                      summa3
              FROM user_list u, routes r, a14mega m
             WHERE     u.dpt_id = :dpt_id
                   AND r.dpt_id = :dpt_id
                   AND m.dpt_id = :dpt_id
                   AND m.tp_kod = r.tp_kod
                   /*AND r.tab_number = m.tab_num*/
                   AND r.tab_number = u.tab_num
                   AND (r.dw_num IN (-1) OR '-1' = '-1')
                   AND m.dt BETWEEN ADD_MONTHS (TO_DATE ( :dt, 'dd.mm.yyyy'), -3)
                                AND TO_DATE ( :dt, 'dd.mm.yyyy')
                   AND u.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :tn)
          GROUP BY r.ts,
                   r.eta,
                   r.h_eta,
                   r.tp_kod,
                   r.tp_name,
                   r.address,
                   r.tp_place,
                   r.tp_type,
                   r.tab_number) r1,
         tpplan p,
         (SELECT tp_kod,
                 dpt_id,
                 discount,
                 bonus
            FROM sc_tp
           WHERE     (discount > 0 OR bonus > 0 OR fixed > 0 OR margin > 0)
                 AND dpt_id = :dpt_id) t,
         user_list u
   WHERE     p.dt(+) = TO_DATE ( :dt, 'dd.mm.yyyy')
         AND p.tp_kod(+) = r1.tp_kod
         AND r1.tp_kod = t.tp_kod(+)
         AND r1.tab_number = u.tab_num
         AND u.dpt_id = :dpt_id
         AND (   :exp_list_without_ts = 0
                      OR u.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_without_ts))
         AND (   :exp_list_only_ts = 0
                      OR u.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_only_ts))
         AND u.tn IN (SELECT slave
                        FROM full
                       WHERE master = DECODE ( :tn, -1, master, :tn))
         AND (:eta_list is null OR :eta_list = r1.h_eta)
ORDER BY r1.ts,
         r1.eta,
         r1.tp_name,
         r1.address)
