/* Formatted on 11.01.2013 13:50:51 (QP5 v5.163.1008.3004) */
  SELECT COUNT (*) c1, SUM (d.summa) summa, SUM (ya) fakt_ya
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