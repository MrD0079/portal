/* Formatted on 22.02.2013 15:50:34 (QP5 v5.163.1008.3004) */
  SELECT a13_pavk.tab_num,
         st.fio fio_ts,
         a13_pavk.fio_eta,
         a13_pavk.tp_ur,
         a13_pavk.tp_addr,
         a13_pavk.tp_kod,
         a13_pavktps.selected,
         NVL (a13_pavktps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a13_pavk.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a13_pavk_tp_select a13_pavktps, a13_pavk, user_list st
   WHERE     a13_pavk.tab_num = st.tab_num
         AND (st.tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a13_pavk.tp_kod = a13_pavktps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a13_pavk.h_fio_eta, :eta_list) = a13_pavk.h_fio_eta
         AND a13_pavktps.selected = 1
GROUP BY a13_pavk.tab_num,
         st.fio,
         a13_pavk.fio_eta,
         a13_pavk.tp_ur,
         a13_pavk.tp_addr,
         a13_pavk.tp_kod,
         a13_pavktps.selected,
         a13_pavktps.contact_lpr
ORDER BY st.fio,
         a13_pavk.fio_eta,
         a13_pavk.tp_ur,
         a13_pavk.tp_addr