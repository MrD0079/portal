/* Formatted on 16.11.2016 17:29:46 (QP5 v5.252.13127.32867) */
SELECT d.tp_kod,
       (NVL (m3.summa, 0) + NVL (m3.coffee, 0) - NVL (m3.s_ya, 0)) fakt3,
       (NVL (m4.summa, 0) + NVL (m4.coffee, 0) - NVL (m4.s_ya, 0)) fakt4,
       (NVL (m3.summa, 0) + NVL (m3.coffee, 0) - NVL (m3.s_ya, 0)) * 1.7
          plan4,
         DECODE (
            NVL ( (NVL (m3.summa, 0) + NVL (m3.coffee, 0) - NVL (m3.s_ya, 0)), 0),
            0, 0,
              (NVL (m4.summa, 0) + NVL (m4.coffee, 0) - NVL (m4.s_ya, 0))
            / (  (NVL (m3.summa, 0) + NVL (m3.coffee, 0) - NVL (m3.s_ya, 0))
               * 1.7))
       * 100
          perc,
       CASE
          WHEN   DECODE (
                    NVL (
                       (  NVL (m3.summa, 0)
                        + NVL (m3.coffee, 0)
                        - NVL (m3.s_ya, 0)),
                       0),
                    0, 0,
                      (NVL (m4.summa, 0) + NVL (m4.coffee, 0) - NVL (m4.s_ya, 0))
                    / (  (  NVL (m3.summa, 0)
                          + NVL (m3.coffee, 0)
                          - NVL (m3.s_ya, 0))
                       * 1.7))
               * 100 >= 100
          THEN
             (NVL (m4.summa, 0) + NVL (m4.coffee, 0) - NVL (m4.s_ya, 0)) * 0.05
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
  FROM a16115p d,
       user_list st,
       a16115p_select tp,
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
                          WHERE master = DECODE ( :tn, -1, master, :tn))
            OR (SELECT NVL (is_traid, 0)
                  FROM user_list
                 WHERE tn = :tn) = 1)
       AND st.dpt_id = :dpt_id and st.is_spd=1
       AND d.tp_kod = tp.tp_kod
       AND DECODE ( :eta_list, '', m4.h_eta, :eta_list) = m4.h_eta
       AND DECODE ( :ok_bonus, 0, 0, DECODE (tp.bonus_dt1, NULL, 2, 1)) =
              :ok_bonus
       AND (   :ok_plan = 0
            OR :ok_plan =
                  CASE
                     WHEN   DECODE (
                               NVL (
                                  (  NVL (m3.summa, 0)
                                   + NVL (m3.coffee, 0)
                                   - NVL (m3.s_ya, 0)),
                                  0),
                               0, 0,
                                 (NVL (m4.summa, 0) + NVL (m4.coffee, 0) - NVL (m4.s_ya, 0))
                               / (  (  NVL (m3.summa, 0)
                                     + NVL (m3.coffee, 0)
                                     - NVL (m3.s_ya, 0))
                                  * 1.7))
                          * 100 >= 100
                     THEN
                        1
                     ELSE
                        2
                  END)
       AND d.tp_kod = m3.tp_kod(+)
       AND m3.dt(+) = TO_DATE ('01/10/2016', 'dd/mm/yyyy')
       AND d.tp_kod = m4.tp_kod
       AND m4.dt = TO_DATE ('01/11/2016', 'dd/mm/yyyy')