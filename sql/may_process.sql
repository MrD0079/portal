/* Formatted on 11.01.2013 13:24:43 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT may.tab_number tab_num,
                  may.ts fio_ts,
                  may.eta fio_eta,
                  may.tp_name tp_ur,
                  may.address tp_addr,
                  may.tp_kod,
                  maytps.selected,
                  maytps.contact_lpr
    FROM may_tp_select maytps, may may, spdtree st
   WHERE     may.tab_number = st.tab_num
         AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
         AND may.tp_kod = maytps.tp_kod(+)
         AND may.eta = maytps.fio_eta(+)
         AND maytps.selected = 1
         AND st.dpt_id = :dpt_id
ORDER BY may.ts,
         may.eta,
         may.tp_name,
         may.address