  SELECT a1812nyb.tab_num,
         st.fio fio_ts,
         a1812nyb.fio_eta,
         a1812nyb.tp_ur,
         a1812nyb.tp_addr,
         a1812nyb.tp_kod,
         DECODE (a1812nybtps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1812nybtps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1812nyb.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1812nyb_select a1812nybtps, a1812nyb, user_list st
   WHERE     a1812nyb.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1812nyb.tp_kod = a1812nybtps.tp_kod(+)
         AND st.dpt_id = :dpt_id
         AND st.is_spd = 1
GROUP BY a1812nyb.tab_num,
         st.fio,
         a1812nyb.fio_eta,
         a1812nyb.tp_ur,
         a1812nyb.tp_addr,
         a1812nyb.tp_kod,
         a1812nybtps.contact_lpr,
         DECODE (a1812nybtps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1812nyb.fio_eta, a1812nyb.tp_ur