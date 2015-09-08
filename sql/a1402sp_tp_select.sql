/* Formatted on 24.02.2014 9:55:34 (QP5 v5.227.12220.39724) */
  SELECT a1402sp.tab_num,
         st.fio fio_ts,
         a1402sp.fio_eta,
         a1402sp.tp_ur,
         a1402sp.tp_addr,
         a1402sp.tp_kod,
         DECODE (a1402sptps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1402sptps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1402sp.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1402sp_tp_select a1402sptps, a1402sp, user_list st
   WHERE     a1402sp.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1402sp.tp_kod = a1402sptps.tp_kod(+)
         AND st.dpt_id = :dpt_id
GROUP BY a1402sp.tab_num,
         st.fio,
         a1402sp.fio_eta,
         a1402sp.tp_ur,
         a1402sp.tp_addr,
         a1402sp.tp_kod,
         a1402sptps.contact_lpr,
         DECODE (a1402sptps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1402sp.fio_eta, a1402sp.tp_ur