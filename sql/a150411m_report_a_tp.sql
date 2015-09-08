/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a150411m.tab_num,
         st.fio fio_ts,
         a150411m.fio_eta,
         a150411m.tp_ur,
         a150411m.tp_addr,
         a150411m.tp_kod,
         a150411mtps.contact_lpr
    FROM a150411m_tp_select a150411mtps, a150411m, user_list st
   WHERE     a150411m.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a150411m.tp_kod = a150411mtps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a150411m.h_fio_eta, :eta_list) =
                a150411m.h_fio_eta
GROUP BY a150411m.tab_num,
         st.fio,
         a150411m.fio_eta,
         a150411m.tp_ur,
         a150411m.tp_addr,
         a150411m.tp_kod,
         a150411mtps.contact_lpr
ORDER BY st.fio,
         a150411m.fio_eta,
         a150411m.tp_ur,
         a150411m.tp_addr