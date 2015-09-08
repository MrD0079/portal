/* Formatted on 11.01.2013 13:26:05 (QP5 v5.163.1008.3004) */
SELECT COUNT (*) c1,
       COUNT (DISTINCT d.tp_kod) tp_kod,
       SUM (an.ok_traid) ok_traid,
       SUM (an.ok_ts) ok_ts,
       SUM (an.ok_chief) ok_chief,
       SUM (an.summa) summa,
       SUM (an.bonus) bonus,
       SUM (an.bonus_plan) bonus_plan,
       DECODE (SUM (an.summa), 0, 0, SUM (an.bonus) / SUM (an.summa) * 100) perc
  FROM may_tp_select maytps,
       (SELECT DISTINCT tab_number tab_num,
                        ts fio_ts,
                        eta fio_eta,
                        tp_name tp_ur,
                        address tp_addr,
                        tp_kod
          FROM may) d,
       may_action_nakl an,
       spdtree st
 WHERE     d.tab_num = st.tab_num
       AND d.tp_kod = maytps.tp_kod
       AND d.fio_eta = maytps.fio_eta
       AND d.tp_kod = an.tp_kod
       AND d.fio_eta = an.fio_eta
       AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts, 0, :tn, :exp_list_without_ts))
       AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts, 0, :tn, :exp_list_only_ts))
       AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
       AND an.ok_traid = 1
       AND DECODE (:ok_ts,  1, 0,  2, 1,  3, 0) = DECODE (:ok_ts, 1, 0, an.ok_ts)
       AND DECODE (:ok_chief,  1, 0,  2, 1,  3, 0) = DECODE (:ok_chief, 1, 0, an.ok_chief)
       AND DECODE (:giveup_check, 0, 0, NVL (an.ok_ts, 0)) = :giveup_check
       AND st.dpt_id = :dpt_id