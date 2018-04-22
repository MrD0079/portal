/* Formatted on 19.08.2017 11:43:39 (QP5 v5.252.13127.32867) */
  SELECT a1804ceg.tab_num,
         st.fio fio_ts,
         a1804ceg.fio_eta,
         a1804ceg.tp_ur,
         a1804ceg.tp_addr,
         a1804ceg.tp_kod,
         DECODE (a1804cegtps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1804cegtps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1804ceg.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1804ceg_select a1804cegtps, a1804ceg, user_list st
   WHERE     a1804ceg.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1804ceg.tp_kod = a1804cegtps.tp_kod(+)
         AND st.dpt_id = :dpt_id
         AND st.is_spd = 1
GROUP BY a1804ceg.tab_num,
         st.fio,
         a1804ceg.fio_eta,
         a1804ceg.tp_ur,
         a1804ceg.tp_addr,
         a1804ceg.tp_kod,
         a1804cegtps.contact_lpr,
         DECODE (a1804cegtps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1804ceg.fio_eta, a1804ceg.tp_ur