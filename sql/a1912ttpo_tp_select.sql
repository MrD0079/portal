/* Formatted on 29/01/2015 12:13:36 (QP5 v5.227.12220.39724) */
  SELECT a1912ttpo.tab_num,
         st.fio fio_ts,
         a1912ttpo.fio_eta,
         a1912ttpo.tp_ur,
         a1912ttpo.tp_addr,
         a1912ttpo.tp_kod,
         DECODE (a1912ttpotps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1912ttpotps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1912ttpo.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1912ttpo_tp_select a1912ttpotps, a1912ttpo, user_list st
   WHERE     a1912ttpo.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1912ttpo.tp_kod = a1912ttpotps.tp_kod(+)
         AND st.dpt_id = :dpt_id and st.is_spd=1
GROUP BY a1912ttpo.tab_num,
         st.fio,
         a1912ttpo.fio_eta,
         a1912ttpo.tp_ur,
         a1912ttpo.tp_addr,
         a1912ttpo.tp_kod,
         a1912ttpotps.contact_lpr,
         DECODE (a1912ttpotps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1912ttpo.fio_eta, a1912ttpo.tp_ur