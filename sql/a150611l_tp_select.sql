/* Formatted on 29/01/2015 12:13:36 (QP5 v5.227.12220.39724) */
  SELECT a150611l.tab_num,
         st.fio fio_ts,
         a150611l.fio_eta,
         a150611l.tp_ur,
         a150611l.tp_addr,
         a150611l.tp_kod,
         DECODE (a150611ltps.tp_kod, NULL, NULL, 1) selected,
         NVL (a150611ltps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a150611l.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a150611l_tp_select a150611ltps, a150611l, user_list st
   WHERE     a150611l.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a150611l.tp_kod = a150611ltps.tp_kod(+)
         AND st.dpt_id = :dpt_id and st.is_spd=1
GROUP BY a150611l.tab_num,
         st.fio,
         a150611l.fio_eta,
         a150611l.tp_ur,
         a150611l.tp_addr,
         a150611l.tp_kod,
         a150611ltps.contact_lpr,
         DECODE (a150611ltps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a150611l.fio_eta, a150611l.tp_ur