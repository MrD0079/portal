/* Formatted on 29/01/2015 12:13:36 (QP5 v5.227.12220.39724) */
  SELECT a1808sb5.tab_num,
         st.fio fio_ts,
         a1808sb5.fio_eta,
         a1808sb5.tp_ur,
         a1808sb5.tp_addr,
         a1808sb5.tp_kod,
         DECODE (a1808sb5tps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1808sb5tps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1808sb5.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1808sb5_tp_select a1808sb5tps, a1808sb5, user_list st
   WHERE     a1808sb5.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1808sb5.tp_kod = a1808sb5tps.tp_kod(+)
         AND st.dpt_id = :dpt_id and st.is_spd=1
GROUP BY a1808sb5.tab_num,
         st.fio,
         a1808sb5.fio_eta,
         a1808sb5.tp_ur,
         a1808sb5.tp_addr,
         a1808sb5.tp_kod,
         a1808sb5tps.contact_lpr,
         DECODE (a1808sb5tps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1808sb5.fio_eta, a1808sb5.tp_ur