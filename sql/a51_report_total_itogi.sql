/* Formatted on 11.01.2013 12:45:07 (QP5 v5.163.1008.3004) */
  SELECT COUNT (*) c1,
         SUM (d.action_qt_ya) action_qt_ya,
         SUM (d.summa) summa,
         SUM (d.action_sum) action_sum,
         SUM (d.action_qt_sku) action_qt_sku,
         SUM (ya) fakt_ya,
         SUM (NVL (an.ok_ts, 0)) ok_ts,
         SUM (NVL (an.ok_traid, 0)) ok_traid
    FROM a51_tp_select a51tps,
         a51 d,
         a51_action_nakl an,
         spdtree st
   WHERE     d.tab_num = st.tab_num
         AND d.tp_kod = a51tps.tp_kod(+)
         AND d.fio_eta = a51tps.fio_eta(+)
         AND TRIM (REPLACE (d.nakl, ' ', '')) = an.nakl
         AND d.tp_kod = an.tp_kod(+)
         AND d.fio_eta = an.fio_eta(+)
         AND TRIM (REPLACE (d.nakl, ' ', '')) = an.nakl(+)
         AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts, 0, :tn, :exp_list_without_ts))
         AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts, 0, :tn, :exp_list_only_ts))
         AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
         AND ok_traid = 1
         AND DECODE (:ok_ts,  1, 0,  2, 1,  3, 0) = DECODE (:ok_ts, 1, 0, an.ok_ts)
         AND DECODE (:ok_chief,  1, 0,  2, 1,  3, 0) = DECODE (:ok_chief, 1, 0, an.ok_chief)
         AND DECODE (:giveup_check, 0, 0, NVL (an.ok_ts, 0)) = :giveup_check
         AND DECODE (:per,  1, SYSDATE,  2, TO_DATE ('01.03.2012', 'dd/mm/yyyy'),  3, TO_DATE ('01.04.2012', 'dd/mm/yyyy')) = DECODE (:per, 1, SYSDATE, TRUNC (d.data, 'mm'))
         AND st.dpt_id = :dpt_id
ORDER BY d.data, REPLACE (d.nakl, ' ', '')