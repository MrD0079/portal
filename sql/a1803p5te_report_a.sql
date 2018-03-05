/* Formatted on 18.12.2017 13:08:17 (QP5 v5.252.13127.32867) */
SELECT d.tp_kod,
       d.plan,
       d.fact,
       DECODE (NVL (d.plan, 0), 0, 0, d.fact / d.plan * 100) perc,
       d.plan_target,
       d.fact_target,
       DECODE (NVL (d.plan_target, 0), 0, 0, d.fact_target / d.plan_target * 100) perc_target,
       CASE
          WHEN     DECODE (NVL (d.plan, 0), 0, 0, d.fact / d.plan * 100) >= 100
               AND DECODE (NVL (d.plan_target, 0),
                           0, 0,
                           d.fact_target / d.plan_target * 100) >= 100
          THEN
             NVL (d.fact, 0) * 0.05
       END
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
  FROM a1803p5te d, user_list st, a1803p5te_select tp
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
       AND DECODE ( :ok_bonus, 0, 0, DECODE (tp.bonus_dt1, NULL, 2, 1)) =
              :ok_bonus
       AND (   :ok_plan = 0
            OR :ok_plan =
                  CASE
                     WHEN DECODE (NVL (d.plan, 0), 0, 0, d.fact / d.plan * 100) >=
                             100
                     THEN
                        1
                     ELSE
                        2
                  END)