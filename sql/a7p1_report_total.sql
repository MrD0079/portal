/* Formatted on 11.09.2012 16:29:01 (QP5 v5.163.1008.3004) */
SELECT COUNT (*) c1,
       SUM (d.summa) summa,
       SUM (d.summnds_pg) summnds_pg,
       SUM (d.action_sum_ya) action_sum_ya_sum,
       AVG (d.action_sum_ya) action_sum_ya_avg,
       SUM (d.action_qt_ya) action_qt_ya_sum,
       AVG (d.action_qt_ya) action_qt_ya_avg,
       SUM (an.ya) fakt_ya,
       SUM (an.bonus) bonus,
       COUNT (DISTINCT d.tp_kod) tp_kod,
       SUM (NVL (an.ok_traid, 0)) ok_traid,
       SUM (NVL (an.ok_ts, 0)) ok_ts,
       SUM (NVL (an.ok_chief, 0)) ok_chief,
       DECODE (SUM (d.summnds_pg),
               0, 0,
               SUM (an.bonus) / SUM (d.summnds_pg) * 100)
          zat_perc
  FROM a4p1 d,
       a7p1_action_nakl an,
       user_list st,
       a7p1_tp_select ts
 WHERE d.tab_num = st.tab_num
       AND st.tn IN
              (SELECT slave
                                 FROM full
                                WHERE master =
                         DECODE (:exp_list_without_ts,
                                 0, :tn,
                                 :exp_list_without_ts))
       AND st.tn IN
              (SELECT slave
                                 FROM full
                                WHERE master =
                         DECODE (:exp_list_only_ts,
                                 0, :tn,
                                 :exp_list_only_ts))
       AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
       AND st.dpt_id = :dpt_id
       AND d.tp_kod = an.tp_kod
       AND d.nakl = an.nakl
       AND d.tp_kod = ts.tp_kod
       AND DECODE (:ok_traid,  1, 0,  2, 1) =
              DECODE (:ok_traid,  1, 0,  2, an.ok_traid)
       AND DECODE (:eta_list, '', d.fio_eta, :eta_list) = d.fio_eta
       and ts.selected=1
