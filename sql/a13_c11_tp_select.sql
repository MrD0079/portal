/* Formatted on 22.02.2013 10:02:47 (QP5 v5.163.1008.3004) */
  SELECT a13_c11.tab_num,
         st.fio fio_ts,
         a13_c11.fio_eta,
         a13_c11.tp_ur,
         a13_c11.tp_addr,
         a13_c11.tp_kod,
         a13_c11tps.selected,
         NVL (a13_c11tps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a13_c11.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a13_c11_tp_select a13_c11tps, a13_c11, user_list st
   WHERE     a13_c11.tab_num = st.tab_num
         AND (st.tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a13_c11.tp_kod = a13_c11tps.tp_kod(+)
         AND st.dpt_id = :dpt_id
         AND a13_c11.data BETWEEN TO_DATE ('01.01.2013', 'dd.mm.yyyy') AND TO_DATE ('12.05.2013', 'dd.mm.yyyy')
GROUP BY a13_c11.tab_num,
         st.fio,
         a13_c11.fio_eta,
         a13_c11.tp_ur,
         a13_c11.tp_addr,
         a13_c11.tp_kod,
         a13_c11tps.selected,
         a13_c11tps.contact_lpr
ORDER BY st.fio, a13_c11.fio_eta, a13_c11.tp_ur