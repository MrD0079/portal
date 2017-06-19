/* Formatted on 29/01/2015 12:13:36 (QP5 v5.227.12220.39724) */
  SELECT a150411m.tab_num,
         st.fio fio_ts,
         a150411m.fio_eta,
         a150411m.tp_ur,
         a150411m.tp_addr,
         a150411m.tp_kod,
         DECODE (a150411mtps.tp_kod, NULL, NULL, 1) selected,
         NVL (a150411mtps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a150411m.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a150411m_tp_select a150411mtps, a150411m, user_list st
   WHERE     a150411m.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a150411m.tp_kod = a150411mtps.tp_kod(+)
         AND st.dpt_id = :dpt_id and st.is_spd=1
GROUP BY a150411m.tab_num,
         st.fio,
         a150411m.fio_eta,
         a150411m.tp_ur,
         a150411m.tp_addr,
         a150411m.tp_kod,
         a150411mtps.contact_lpr,
         DECODE (a150411mtps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a150411m.fio_eta, a150411m.tp_ur