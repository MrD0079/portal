/* Formatted on 22.02.2013 15:50:34 (QP5 v5.163.1008.3004) */
  SELECT val_bumvesna.tab_num,
         st.fio fio_ts,
         val_bumvesna.fio_eta,
         val_bumvesna.tp_ur,
         val_bumvesna.tp_addr,
         val_bumvesna.tp_kod,
         val_bumvesnatps.selected,
         NVL (val_bumvesnatps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = val_bumvesna.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM val_bumvesna_tp_select val_bumvesnatps, val_bumvesna, user_list st
   WHERE     val_bumvesna.tab_num = st.tab_num
         AND (st.tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND val_bumvesna.tp_kod = val_bumvesnatps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', val_bumvesna.h_fio_eta, :eta_list) = val_bumvesna.h_fio_eta
         AND val_bumvesnatps.selected = 1
GROUP BY val_bumvesna.tab_num,
         st.fio,
         val_bumvesna.fio_eta,
         val_bumvesna.tp_ur,
         val_bumvesna.tp_addr,
         val_bumvesna.tp_kod,
         val_bumvesnatps.selected,
         val_bumvesnatps.contact_lpr
ORDER BY st.fio,
         val_bumvesna.fio_eta,
         val_bumvesna.tp_ur,
         val_bumvesna.tp_addr