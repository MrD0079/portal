/* Formatted on 19.08.2017 11:43:39 (QP5 v5.252.13127.32867) */
  SELECT a1806ch.tab_num,
         st.fio fio_ts,
         a1806ch.fio_eta,
         a1806ch.tp_ur,
         a1806ch.tp_addr,
         a1806ch.tp_kod,
         DECODE (a1806chtps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1806chtps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1806ch.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1806ch_select a1806chtps, a1806ch, user_list st
   WHERE     a1806ch.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1806ch.tp_kod = a1806chtps.tp_kod(+)
         AND st.dpt_id = :dpt_id
         AND st.is_spd = 1
GROUP BY a1806ch.tab_num,
         st.fio,
         a1806ch.fio_eta,
         a1806ch.tp_ur,
         a1806ch.tp_addr,
         a1806ch.tp_kod,
         a1806chtps.contact_lpr,
         DECODE (a1806chtps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1806ch.fio_eta, a1806ch.tp_ur