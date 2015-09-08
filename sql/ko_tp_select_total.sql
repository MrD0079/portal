/* Formatted on 11.01.2013 13:23:14 (QP5 v5.163.1008.3004) */
SELECT NVL (SUM (selected), 0) selected
  FROM (SELECT DISTINCT kotps.tp_kod, kotps.fio_eta, kotps.selected
          FROM ko_tp_select kotps, val_mart ko, spdtree st
         WHERE     ko.tab_num = st.tab_num
               AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
               AND ko.tp_kod = kotps.tp_kod(+)
               AND ko.fio_eta = kotps.fio_eta(+)
               AND kotps.selected = 1
               AND st.dpt_id = :dpt_id)