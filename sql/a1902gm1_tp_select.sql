  SELECT a1902gm1.tab_num,
         st.fio fio_ts,
         a1902gm1.fio_eta,
         a1902gm1.tp_ur,
         a1902gm1.tp_addr,
         a1902gm1.tp_kod,
         DECODE (a1902gm1tps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1902gm1tps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1902gm1.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1902gm1_select a1902gm1tps, a1902gm1, user_list st
   WHERE     a1902gm1.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1902gm1.tp_kod = a1902gm1tps.tp_kod(+)
         AND st.dpt_id = :dpt_id
         AND st.is_spd = 1
         AND (SELECT count(gm2.tp_kod) FROM a1902gm2_select gm2 WHERE gm2.tp_kod = a1902gm1.tp_kod) = 0
         AND (SELECT count(gm3.tp_kod) FROM a1902gm3_select gm3 WHERE gm3.tp_kod = a1902gm1.tp_kod) = 0
GROUP BY a1902gm1.tab_num,
         st.fio,
         a1902gm1.fio_eta,
         a1902gm1.tp_ur,
         a1902gm1.tp_addr,
         a1902gm1.tp_kod,
         a1902gm1tps.contact_lpr,
         DECODE (a1902gm1tps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1902gm1.fio_eta, a1902gm1.tp_ur