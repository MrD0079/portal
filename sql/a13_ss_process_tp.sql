/* Formatted on 22.02.2013 15:50:34 (QP5 v5.163.1008.3004) */
  SELECT a13_ss.tab_num,
         st.fio fio_ts,
         a13_ss.fio_eta,
         a13_ss.tp_ur,
         a13_ss.tp_addr,
         a13_ss.tp_kod,
         a13_sstps.selected,
         NVL (a13_sstps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a13_ss.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a13_ss_tp_select a13_sstps, a13_ss, user_list st
   WHERE     a13_ss.tab_num = st.tab_num
         AND (st.tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a13_ss.tp_kod = a13_sstps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a13_ss.h_fio_eta, :eta_list) = a13_ss.h_fio_eta
         AND a13_sstps.selected = 1
         /*AND a13_ss.data BETWEEN TO_DATE ('13.05.2013', 'dd.mm.yyyy') AND TO_DATE ('31.05.2013', 'dd.mm.yyyy')*/
GROUP BY a13_ss.tab_num,
         st.fio,
         a13_ss.fio_eta,
         a13_ss.tp_ur,
         a13_ss.tp_addr,
         a13_ss.tp_kod,
         a13_sstps.selected,
         a13_sstps.contact_lpr
ORDER BY st.fio,
         a13_ss.fio_eta,
         a13_ss.tp_ur,
         a13_ss.tp_addr