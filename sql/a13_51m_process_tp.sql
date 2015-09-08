/* Formatted on 22.02.2013 15:50:34 (QP5 v5.163.1008.3004) */
  SELECT a13_51m.tab_num,
         st.fio fio_ts,
         a13_51m.fio_eta,
         a13_51m.tp_ur,
         a13_51m.tp_addr,
         a13_51m.tp_kod,
         a13_51mtps.selected,
         NVL (a13_51mtps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a13_51m.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a13_51m_tp_select a13_51mtps, a13_51m, user_list st
   WHERE     a13_51m.tab_num = st.tab_num
         AND (st.tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a13_51m.tp_kod = a13_51mtps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a13_51m.h_fio_eta, :eta_list) = a13_51m.h_fio_eta
         AND a13_51mtps.selected = 1
GROUP BY a13_51m.tab_num,
         st.fio,
         a13_51m.fio_eta,
         a13_51m.tp_ur,
         a13_51m.tp_addr,
         a13_51m.tp_kod,
         a13_51mtps.selected,
         a13_51mtps.contact_lpr
ORDER BY st.fio,
         a13_51m.fio_eta,
         a13_51m.tp_ur,
         a13_51m.tp_addr