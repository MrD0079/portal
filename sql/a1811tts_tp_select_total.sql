SELECT SUM (selected)
  FROM (
  SELECT a1811tts.tab_num,
         st.fio fio_ts,
         a1811tts.fio_eta,
         a1811tts.tp_ur,
         a1811tts.tp_addr,
         a1811tts.tp_kod,
         DECODE (a1811ttstps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1811ttstps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1811tts.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1811tts_select a1811ttstps, a1811tts, user_list st
   WHERE     a1811tts.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1811tts.tp_kod = a1811ttstps.tp_kod(+)
         AND st.dpt_id = :dpt_id
         AND st.is_spd = 1
GROUP BY a1811tts.tab_num,
         st.fio,
         a1811tts.fio_eta,
         a1811tts.tp_ur,
         a1811tts.tp_addr,
         a1811tts.tp_kod,
         a1811ttstps.contact_lpr,
         DECODE (a1811ttstps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1811tts.fio_eta, a1811tts.tp_ur)