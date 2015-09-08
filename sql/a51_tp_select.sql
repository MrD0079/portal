/* Formatted on 11.01.2013 12:45:52 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT a51.tab_num,
                  a51.fio_ts,
                  a51.fio_eta,
                  a51.tp_ur,
                  a51.tp_addr,
                  a51.tp_kod,
                  a51tps.selected,
                  a51tps.contact_lpr
    FROM a51_tp_select a51tps, a51, spdtree st
   WHERE     a51.tab_num = st.tab_num
         AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
         AND a51.tp_kod = a51tps.tp_kod(+)
         AND a51.fio_eta = a51tps.fio_eta(+)
         AND st.dpt_id = :dpt_id
ORDER BY a51.fio_ts,
         a51.fio_eta,
         a51.tp_ur,
         a51.tp_addr