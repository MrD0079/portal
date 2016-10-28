/* Formatted on 11/05/2016 09:41:34 (QP5 v5.252.13127.32867) */
  SELECT h_net,
         net,
         SUM (fakt3) fakt3,
         SUM (plan4) plan4,
         SUM (fakt4) fakt4,
         DECODE (NVL (SUM (fakt3), 0), 0, 0, SUM (fakt4) / (SUM (plan4))) * 100
            perc,
         ROUND (
            CASE
               WHEN   DECODE (NVL (SUM (fakt3), 0),
                              0, 0,
                              SUM (fakt4) / (SUM (plan4)))
                    * 100 >= 100
               THEN
                  SUM (fakt4) * 0.05
            END,
            2)
            max_bonus,
         COUNT (*) tp_cnt,
         SUM (bonus_sum1) bonus_sum1,
         COUNT (DISTINCT DECODE (bonus_dt1, NULL, NULL, h_net)) bonus_dt1,
         wm_concat (DISTINCT ok_chief_date) ok_chief_date,
         wm_concat (DISTINCT ok_chief) ok_chief,
         wm_concat (DISTINCT parent_fio) parent_fio,
         wm_concat (DISTINCT parent_tn) parent_tn
    FROM (SELECT n.h_net,
                 n.net,
                 n.tp_kod,
                 m3.summa fakt3,
                 m4.summa fakt4,
                 m3.summa * 1.5 plan4,
                   DECODE (NVL (m3.summa, 0),
                           0, 0,
                           m4.summa / (m3.summa * 1.5))
                 * 100
                    perc,
                 ROUND (
                    CASE
                       WHEN   DECODE (NVL (m3.summa, 0),
                                      0, 0,
                                      m4.summa / (m3.summa * 1.5))
                            * 100 >= 100
                       THEN
                          m4.summa * 0.05
                    END,
                    2)
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
            FROM a16p5net d,
                 user_list st,
                 a16p5net_select net,
                 a16p5n_nettp tp,
                 a14mega m3,
                 a14mega m4,
                 (SELECT n.*
                    FROM tp_nets n,
                         (SELECT DISTINCT tpn.h_net
                            FROM tp_nets tpn, a14mega m, user_list u
                           WHERE     tpn.tp_kod = m.tp_kod
                                 AND m.tab_num = u.tab_num
                                 AND u.dpt_id = :dpt_id
                                 AND (   u.tn IN (SELECT slave
                                                    FROM full
                                                   WHERE master =
                                                            DECODE ( :tn,
                                                                    -1, master,
                                                                    :tn))
                                      OR (SELECT NVL (is_traid, 0)
                                            FROM user_list
                                           WHERE tn = :tn) = 1)
                                 AND m.dt =
                                        TO_DATE ('01/04/2016', 'dd/mm/yyyy'))
                         tpn
                   WHERE n.h_net = tpn.h_net) n
           WHERE     m4.tab_num = st.tab_num
                 AND (   :exp_list_without_ts = 0
                      OR st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :exp_list_without_ts))
                 AND (   :exp_list_only_ts = 0
                      OR st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :exp_list_only_ts))
                 AND st.dpt_id = :dpt_id
                 AND n.h_net = net.net_kod
                 AND n.tp_kod = tp.tp_kod(+)
                 AND DECODE ( :eta_list, '', m4.h_eta, :eta_list) = m4.h_eta
                 AND n.tp_kod = m3.tp_kod(+)
                 AND m3.dt(+) = TO_DATE ('01/03/2016', 'dd/mm/yyyy')
                 AND n.tp_kod = m4.tp_kod
                 AND m4.dt = TO_DATE ('01/04/2016', 'dd/mm/yyyy')
                 AND n.tp_kod = n.tp_kod
                 AND d.net_name = n.net)
GROUP BY h_net, net
  HAVING     (   :ok_plan = 0
              OR :ok_plan =
                    CASE
                       WHEN   DECODE (NVL (SUM (fakt3), 0),
                                      0, 0,
                                      SUM (fakt4) / (SUM (plan4)))
                            * 100 >= 100
                       THEN
                          1
                       ELSE
                          2
                    END)
         AND (   :ok_bonus = 0
              OR :ok_bonus =
                    CASE
                       WHEN COUNT (
                               DISTINCT DECODE (bonus_dt1, NULL, NULL, h_net)) >
                               0
                       THEN
                          1
                       ELSE
                          2
                    END)
ORDER BY net