SELECT COUNT (DISTINCT tp_kod) cnt_tp,
       COUNT (DISTINCT DECODE (max_bonus, NULL, NULL, tp_kod)) if_cnt,
       SUM (plan) plan,
       SUM (fact_target) fact_target,
       SUM (max_bonus) max_bonus,
       SUM (bonus_sum1) bonus_sum1,
       COUNT (DISTINCT DECODE (bonus_dt1, NULL, NULL, tp_kod)) bonus_fakt_cnt,
       DECODE (SUM (fact_target), 0, 0, SUM (bonus_sum1) / SUM (fact_target) * 100) zat
  FROM (SELECT d.tp_kod,
               d.plan,
               d.fact_target,
               DECODE (NVL (d.plan, 0), 0, 0, d.fact_target / d.plan * 100) perc,
               CASE
                  WHEN DECODE (NVL (d.plan, 0), 0, 0, d.fact_target / d.plan * 100) >= 100
                       AND  DECODE (NVL (d.plan_akc, 0), 0, 0, d.fact_akc / d.plan_akc * 100) >= 100
                  THEN
                     CASE
                          WHEN DECODE(NVL(d.fact_target,0), 0 , 0, NVL(d.fact_target,0)) >= 12000 --uslovie 3
                             AND d.fact_akc >= 4
                          THEN 1200

                          WHEN DECODE(NVL(d.fact_target,0), 0 , 0, NVL(d.fact_target,0)) >= 7000 --uslovie 2
                            AND d.fact_akc >= 2
                          THEN 700

                          ELSE NVL (d.plan, 0) * 0.1 --uslovie 1
                     END
                  --ELSE 0
               END
--                CASE
--                WHEN DECODE (NVL (d.plan, 0), 0, 0, d.fact / d.plan * 100) >= 100
--                THEN NVL (d.fact, 0) * 0.05
--                END
                max_bonus,
               d.fio_eta,
               d.tp_ur,
               d.tp_addr,
               tp.bonus_sum1,
               TO_CHAR (tp.bonus_dt1, 'dd.mm.yyyy') bonus_dt1,
               (SELECT TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu
                  FROM ACT_OK
                 WHERE     tn = (SELECT parent
                                   FROM parents
                                  WHERE tn = st.tn)
                       AND m = :month
                       AND act = :act)
                  ok_chief_date,
               (SELECT DECODE (lu, NULL, 0, 1)
                  FROM ACT_OK
                 WHERE     tn = (SELECT parent
                                   FROM parents
                                  WHERE tn = st.tn)
                       AND m = :month
                       AND act = :act)
                  ok_chief,
               fn_getname ( (SELECT parent
                               FROM parents
                              WHERE tn = st.tn))
                  parent_fio,
               (SELECT parent
                  FROM parents
                 WHERE tn = st.tn)
                  parent_tn,
               st.fio ts_fio,
               st.tn ts_tn
          FROM a1811tts d, user_list st, a1811tts_select tp
         WHERE     d.tab_num = st.tab_num
               AND (   :exp_list_without_ts = 0
                    OR st.tn IN (SELECT slave
                                   FROM full
                                  WHERE master = :exp_list_without_ts))
               AND (   :exp_list_only_ts = 0
                    OR st.tn IN (SELECT slave
                                   FROM full
                                  WHERE master = :exp_list_only_ts))
               AND (   st.tn IN (SELECT slave
                                   FROM full
                                  WHERE master = DECODE ( :tn, -1, master, :tn))
                    OR (SELECT NVL (is_traid, 0)
                          FROM user_list
                         WHERE tn = :tn) = 1)
               AND st.dpt_id = :dpt_id
               AND st.is_spd = 1
               AND d.tp_kod = tp.tp_kod
               AND DECODE ( :eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
               AND DECODE ( :ok_bonus, 0, 0, DECODE (tp.bonus_dt1, NULL, 2, 1)) = :ok_bonus
               AND ( :ok_plan = 0
                    OR :ok_plan = CASE
                                    WHEN DECODE (NVL (d.fact_target, 0), 0, 0, d.fact_target / d.plan * 100) >= 100
                                      AND  DECODE (NVL (d.fact_akc, 0), 0, 0, d.fact_akc / d.plan_akc * 100) >= 100
                                    THEN 1
                                    ELSE 2
                                  END)
        )

