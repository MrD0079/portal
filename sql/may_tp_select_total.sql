/* Formatted on 11.01.2013 13:26:24 (QP5 v5.163.1008.3004) */
SELECT NVL (SUM (selected), 0) selected
  FROM (SELECT DISTINCT maytps.tp_kod, maytps.fio_eta, maytps.selected
          FROM may_tp_select maytps, may may, spdtree st
         WHERE     may.tab_number = st.tab_num
               AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
               AND may.tp_kod = maytps.tp_kod(+)
               AND may.eta = maytps.fio_eta(+)
               AND maytps.selected = 1
               AND st.dpt_id = :dpt_id);