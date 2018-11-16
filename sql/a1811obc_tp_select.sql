SELECT a1811obc.tab_num,
         st.fio fio_ts,
         a1811obc.fio_eta,
         a1811obc.tp_ur,
         a1811obc.tp_addr,
         a1811obc.tp_kod,
         DECODE (a1811obctps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1811obctps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1811obc.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1811obc_tp_select a1811obctps, a1811obc, user_list st
   WHERE     a1811obc.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1811obc.tp_kod = a1811obctps.tp_kod(+)
         AND st.dpt_id = :dpt_id and st.is_spd=1
GROUP BY a1811obc.tab_num,
         st.fio,
         a1811obc.fio_eta,
         a1811obc.tp_ur,
         a1811obc.tp_addr,
         a1811obc.tp_kod,
         a1811obctps.contact_lpr,
         DECODE (a1811obctps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1811obc.fio_eta, a1811obc.tp_ur