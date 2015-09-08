/* Formatted on 11.01.2013 12:44:29 (QP5 v5.163.1008.3004) */
  SELECT COUNT (*) c1,
         SUM (d.action_qt_ya) action_qt_ya,
         SUM (d.summa) summa,
         SUM (d.action_sum) action_sum,
         AVG (d.action_qt_sku) action_qt_sku,
         SUM (ya) fakt_ya
    FROM a51 d, a51_action_nakl an, spdtree st
   WHERE     d.tab_num = st.tab_num
         AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
         AND DECODE (:tp || ':eta', 0, d.tp_kod || d.fio_eta, :tp || ':eta') = d.tp_kod || d.fio_eta
         AND DECODE (:tp || ':eta', 0, TRIM (REPLACE (d.nakl, ' ', '')), 0) = DECODE (:tp || ':eta', 0, an.nakl, 0)
         AND d.tp_kod = an.tp_kod(+)
         AND d.fio_eta = an.fio_eta(+)
         AND TRIM (REPLACE (d.nakl, ' ', '')) = an.nakl(+)
         AND st.dpt_id = :dpt_id
ORDER BY d.fio_ts,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.data,
         REPLACE (d.nakl, ' ', '')