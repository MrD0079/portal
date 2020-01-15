  SELECT a1912cd.tab_num,
         st.fio fio_ts,
         a1912cd.fio_eta,
         a1912cd.tp_ur,
         a1912cd.tp_addr,
         a1912cd.tp_kod,
         DECODE (a1912cdtps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1912cdtps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1912cd.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1912cd_select a1912cdtps, a1912cd, user_list st
   WHERE     a1912cd.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1912cd.tp_kod = a1912cdtps.tp_kod(+)
         AND st.dpt_id = :dpt_id
         AND st.is_spd = 1
GROUP BY a1912cd.tab_num,
         st.fio,
         a1912cd.fio_eta,
         a1912cd.tp_ur,
         a1912cd.tp_addr,
         a1912cd.tp_kod,
         a1912cdtps.contact_lpr,
         DECODE (a1912cdtps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1912cd.fio_eta, a1912cd.tp_ur