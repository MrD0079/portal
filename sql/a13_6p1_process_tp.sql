/* Formatted on 22.02.2013 15:50:34 (QP5 v5.163.1008.3004) */
  SELECT a13_6p1.tab_num,
         st.fio fio_ts,
         a13_6p1.fio_eta,
         a13_6p1.tp_ur,
         a13_6p1.tp_addr,
         a13_6p1.tp_kod,
         a13_6p1tps.selected,
         NVL (a13_6p1tps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a13_6p1.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a13_6p1_tp_select a13_6p1tps, a13_6p1, user_list st
   WHERE     a13_6p1.tab_num = st.tab_num
         AND (st.tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a13_6p1.tp_kod = a13_6p1tps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a13_6p1.h_fio_eta, :eta_list) = a13_6p1.h_fio_eta
         AND a13_6p1tps.selected = 1
GROUP BY a13_6p1.tab_num,
         st.fio,
         a13_6p1.fio_eta,
         a13_6p1.tp_ur,
         a13_6p1.tp_addr,
         a13_6p1.tp_kod,
         a13_6p1tps.selected,
         a13_6p1tps.contact_lpr
ORDER BY st.fio,
         a13_6p1.fio_eta,
         a13_6p1.tp_ur,
         a13_6p1.tp_addr