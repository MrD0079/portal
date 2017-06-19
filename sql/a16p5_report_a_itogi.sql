/* Formatted on 27/04/2016 18:00:04 (QP5 v5.252.13127.32867) */
SELECT COUNT (DISTINCT tp_kod) cnt_tp,
       COUNT (DISTINCT DECODE (max_bonus, NULL, NULL, tp_kod)) if_cnt,
       SUM (fakt3) fakt3,
       SUM (plan4) plan4,
       SUM (fakt4) fakt4,
       SUM (max_bonus) max_bonus,
       SUM (bonus_sum1) bonus_sum1,
       COUNT (DISTINCT DECODE (bonus_dt1, NULL, NULL, tp_kod)) bonus_fakt_cnt,
       DECODE (SUM (fakt4), 0, 0, SUM (bonus_sum1) / SUM (fakt4) * 100) zat
  FROM (SELECT d.tp_kod,
               m3.summa fakt3,
               m4.summa fakt4,
               m3.summa * 1.5 plan4,
                 DECODE (NVL (m3.summa, 0),
                         0, 0,
                         m4.summa / (m3.summa * 1.5))
               * 100
                  perc,
               CASE
                  WHEN   DECODE (NVL (m3.summa, 0),
                                 0, 0,
                                 m4.summa / (m3.summa * 1.5))
                       * 100 >= 100
                  THEN
                     m4.summa * 0.05
               END
                  max_bonus,
               m4.eta fio_eta,
               m4.tp_ur,
               m4.tp_addr,
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
          FROM a16p5tp d,
               user_list st,
               a16p5tp_select tp,
               a14mega m3,
               a14mega m4
         WHERE     m4.tab_num = st.tab_num
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
                                  WHERE master =
                                           DECODE ( :tn, -1, master, :tn))
                    OR (SELECT NVL (is_traid, 0)
                          FROM user_list
                         WHERE tn = :tn) = 1)
               AND st.dpt_id = :dpt_id and st.is_spd=1
               AND d.tp_kod = tp.tp_kod
               AND DECODE ( :eta_list, '', m4.h_eta, :eta_list) = m4.h_eta
               AND DECODE ( :ok_bonus,
                           0, 0,
                           DECODE (tp.bonus_dt1, NULL, 2, 1)) = :ok_bonus
               AND (   :ok_plan = 0
                    OR :ok_plan =
                          CASE
                             WHEN   DECODE (NVL (m3.summa, 0),
                                            0, 0,
                                            m4.summa / (m3.summa * 1.5))
                                  * 100 >= 100
                             THEN
                                1
                             ELSE
                                2
                          END)
               AND d.tp_kod = m3.tp_kod(+)
               AND m3.dt(+) = TO_DATE ('01/03/2016', 'dd/mm/yyyy')
               AND d.tp_kod = m4.tp_kod
               AND m4.dt = TO_DATE ('01/04/2016', 'dd/mm/yyyy'))