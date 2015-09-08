/* Formatted on 11.01.2013 13:50:39 (QP5 v5.163.1008.3004) */
  SELECT d.tab_num,
         d.fio_ts,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.tp_kod,
         REPLACE (d.nakl, ' ', '') nakl,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         d.summa,
         CASE WHEN d.summa >= 1250 THEN 1 END action_nakl,
         TRUNC (d.summa / 1250) max_ya,
         DECODE (an.nakl, NULL, 0, 1) selected,
         an.ok_traid,
         an.ok_ts,
         an.ok_chief,
         ya fakt_ya
    FROM val_mart d, val_mart_action_nakl an, spdtree st
   WHERE     d.tab_num = st.tab_num
         AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
         AND st.dpt_id = :dpt_id
         AND DECODE (:tp, 0, d.tp_kod, :tp) = d.tp_kod
         AND DECODE (:tp, 0, TRIM (REPLACE (d.nakl, ' ', '')), 0) = DECODE (:tp, 0, an.nakl, 0)
         AND d.tp_kod = an.tp_kod(+)
         AND TRIM (REPLACE (d.nakl, ' ', '')) = an.nakl(+)
         AND d.data BETWEEN TO_DATE ('15.03.2012', 'dd.mm.yyyy') AND TO_DATE ('30.04.2012', 'dd.mm.yyyy')
ORDER BY d.fio_ts,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.data,
         REPLACE (d.nakl, ' ', '')