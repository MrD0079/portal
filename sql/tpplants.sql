/* Formatted on 17/11/2015 16:35:30 (QP5 v5.252.13127.32867) */
SELECT SUM (val_plan) val_plan,
       SUM (val_plan1) val_plan1,
       SUM (val_plan2) val_plan2,
       SUM (val_plan3) val_plan3,
       SUM (val_plan_avg) val_plan_avg,
       SUM (akb_plan) akb_plan,
       SUM (akb_plan1) akb_plan1,
       SUM (akb_plan2) akb_plan2,
       SUM (akb_plan3) akb_plan3,
       SUM (akb_plan_avg) akb_plan_avg,
       SUM (akb_fact) akb_fact,
       SUM (akb_fact1) akb_fact1,
       SUM (akb_fact2) akb_fact2,
       SUM (akb_fact3) akb_fact3,
       SUM (akb_fact_avg) akb_fact_avg
  FROM (  SELECT r1.ts,
                 r1.eta,
                 m1.val_plan,
                 m1.val_plan1,
                 m1.val_plan2,
                 m1.val_plan3,
                   (  NVL (m1.val_plan1, 0)
                    + NVL (m1.val_plan2, 0)
                    + NVL (m1.val_plan3, 0))
                 / 3
                    val_plan_avg,
                 m1.akb_plan,
                 m1.akb_plan1,
                 m1.akb_plan2,
                 m1.akb_plan3,
                   (  NVL (m1.akb_plan1, 0)
                    + NVL (m1.akb_plan2, 0)
                    + NVL (m1.akb_plan3, 0))
                 / 3
                    akb_plan_avg,
                 m1.akb_fact,
                 m1.akb_fact1,
                 m1.akb_fact2,
                 m1.akb_fact3,
                   (  NVL (m1.akb_fact1, 0)
                    + NVL (m1.akb_fact2, 0)
                    + NVL (m1.akb_fact3, 0))
                 / 3
                    akb_fact_avg
            FROM (SELECT DISTINCT r.ts,
                                  r.eta,
                                  r.h_eta,
                                  r.tab_number,
                                  r.dpt_id
                    FROM routes r
                   WHERE     (r.dw_num IN ( :dw_num) OR ':dw_num' = '-1')
                         AND r.dpt_id = :dpt_id) r1,
                 (  SELECT m.h_eta,
                           m.dpt_id,
                           MAX (
                              CASE
                                 WHEN m.dt = TO_DATE ( :dt, 'dd.mm.yyyy')
                                 THEN
                                    m.val_plan
                              END)
                              val_plan,
                           MAX (
                              CASE
                                 WHEN m.dt =
                                         ADD_MONTHS (
                                            TO_DATE ( :dt, 'dd.mm.yyyy'),
                                            -1)
                                 THEN
                                    m.val_plan
                              END)
                              val_plan1,
                           MAX (
                              CASE
                                 WHEN m.dt =
                                         ADD_MONTHS (
                                            TO_DATE ( :dt, 'dd.mm.yyyy'),
                                            -2)
                                 THEN
                                    m.val_plan
                              END)
                              val_plan2,
                           MAX (
                              CASE
                                 WHEN m.dt =
                                         ADD_MONTHS (
                                            TO_DATE ( :dt, 'dd.mm.yyyy'),
                                            -3)
                                 THEN
                                    m.val_plan
                              END)
                              val_plan3,
                           MAX (
                              CASE
                                 WHEN m.dt = TO_DATE ( :dt, 'dd.mm.yyyy')
                                 THEN
                                    m.akb_plan
                              END)
                              akb_plan,
                           MAX (
                              CASE
                                 WHEN m.dt =
                                         ADD_MONTHS (
                                            TO_DATE ( :dt, 'dd.mm.yyyy'),
                                            -1)
                                 THEN
                                    m.akb_plan
                              END)
                              akb_plan1,
                           MAX (
                              CASE
                                 WHEN m.dt =
                                         ADD_MONTHS (
                                            TO_DATE ( :dt, 'dd.mm.yyyy'),
                                            -2)
                                 THEN
                                    m.akb_plan
                              END)
                              akb_plan2,
                           MAX (
                              CASE
                                 WHEN m.dt =
                                         ADD_MONTHS (
                                            TO_DATE ( :dt, 'dd.mm.yyyy'),
                                            -3)
                                 THEN
                                    m.akb_plan
                              END)
                              akb_plan3,
                           MAX (
                              CASE
                                 WHEN m.dt = TO_DATE ( :dt, 'dd.mm.yyyy')
                                 THEN
                                    m.akb_fact
                              END)
                              akb_fact,
                           MAX (
                              CASE
                                 WHEN m.dt =
                                         ADD_MONTHS (
                                            TO_DATE ( :dt, 'dd.mm.yyyy'),
                                            -1)
                                 THEN
                                    m.akb_fact
                              END)
                              akb_fact1,
                           MAX (
                              CASE
                                 WHEN m.dt =
                                         ADD_MONTHS (
                                            TO_DATE ( :dt, 'dd.mm.yyyy'),
                                            -2)
                                 THEN
                                    m.akb_fact
                              END)
                              akb_fact2,
                           MAX (
                              CASE
                                 WHEN m.dt =
                                         ADD_MONTHS (
                                            TO_DATE ( :dt, 'dd.mm.yyyy'),
                                            -3)
                                 THEN
                                    m.akb_fact
                              END)
                              akb_fact3
                      FROM kpr m
                     WHERE     m.dt BETWEEN ADD_MONTHS (
                                               TO_DATE ( :dt, 'dd.mm.yyyy'),
                                               -3)
                                        AND TO_DATE ( :dt, 'dd.mm.yyyy')
                           AND m.dpt_id = :dpt_id
                  GROUP BY m.h_eta, m.dpt_id) m1,
                 user_list u
           WHERE     r1.tab_number = u.tab_num
                 AND r1.dpt_id = u.dpt_id
                 AND u.dpt_id = :dpt_id
                 AND r1.h_eta = m1.h_eta
                 AND r1.dpt_id = m1.dpt_id
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
        ORDER BY r1.ts, r1.eta)