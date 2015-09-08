/* Formatted on 11.01.2013 12:44:16 (QP5 v5.163.1008.3004) */
  SELECT d.tab_num,
         d.fio_ts,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.tp_kod,
         REPLACE (d.nakl, ' ', '') nakl,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         d.summa,
         d.action_qt_ya,
         d.action_sum,
         d.action_qt_sku,
         CASE WHEN d.action_qt_ya >= 5 THEN 1 END action_nakl,
         TRUNC (d.action_qt_ya / 5) max_ya,
         DECODE (an.nakl, NULL, 0, 1) selected,
         an.ok_traid,
         an.ok_ts,
         an.ok_chief,
         ya fakt_ya
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