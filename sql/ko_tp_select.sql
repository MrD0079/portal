/* Formatted on 11.01.2013 13:23:05 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT ko.tab_num,
                  ko.fio_ts,
                  ko.fio_eta,
                  ko.tp_ur,
                  ko.tp_addr,
                  ko.tp_kod,
                  kotps.selected,
                  kotps.contact_lpr
    FROM ko_tp_select kotps, val_mart ko, spdtree st
   WHERE     ko.tab_num = st.tab_num
         AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
         AND ko.tp_kod = kotps.tp_kod(+)
         AND ko.fio_eta = kotps.fio_eta(+)
         AND st.dpt_id = :dpt_id
ORDER BY ko.fio_ts,
         ko.fio_eta,
         ko.tp_ur,
         ko.tp_addr