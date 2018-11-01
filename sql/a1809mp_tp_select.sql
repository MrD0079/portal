/* Formatted on 19.08.2017 11:43:39 (QP5 v5.252.13127.32867) */
  SELECT a1809mp.tab_num,
         st.fio fio_ts,
         a1809mp.fio_eta,
         a1809mp.tp_ur,
         a1809mp.tp_addr,
         a1809mp.tp_kod,
         DECODE (a1809mptps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1809mptps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1809mp.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1809mp_select a1809mptps, a1809mp, user_list st
   WHERE     a1809mp.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1809mp.tp_kod = a1809mptps.tp_kod(+)
         AND st.dpt_id = :dpt_id
         AND st.is_spd = 1
GROUP BY a1809mp.tab_num,
         st.fio,
         a1809mp.fio_eta,
         a1809mp.tp_ur,
         a1809mp.tp_addr,
         a1809mp.tp_kod,
         a1809mptps.contact_lpr,
         DECODE (a1809mptps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1809mp.fio_eta, a1809mp.tp_ur