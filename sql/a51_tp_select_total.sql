/* Formatted on 11.01.2013 12:46:03 (QP5 v5.163.1008.3004) */
SELECT NVL (SUM (selected), 0) selected
  FROM (SELECT DISTINCT a51tps.tp_kod, a51tps.fio_eta, a51tps.selected
          FROM a51_tp_select a51tps, a51, spdtree st
         WHERE     a51.tab_num = st.tab_num
               AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
               AND a51.tp_kod = a51tps.tp_kod(+)
               AND a51.fio_eta = a51tps.fio_eta(+)
               AND a51tps.selected = 1
               AND st.dpt_id = :dpt_id)