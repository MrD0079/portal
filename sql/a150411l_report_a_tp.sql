/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a150411l.tab_num,
         st.fio fio_ts,
         a150411l.fio_eta,
         a150411l.tp_ur,
         a150411l.tp_addr,
         a150411l.tp_kod,
         a150411ltps.contact_lpr
    FROM a150411l_tp_select a150411ltps, a150411l, user_list st
   WHERE     a150411l.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a150411l.tp_kod = a150411ltps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a150411l.h_fio_eta, :eta_list) =
                a150411l.h_fio_eta
GROUP BY a150411l.tab_num,
         st.fio,
         a150411l.fio_eta,
         a150411l.tp_ur,
         a150411l.tp_addr,
         a150411l.tp_kod,
         a150411ltps.contact_lpr
ORDER BY st.fio,
         a150411l.fio_eta,
         a150411l.tp_ur,
         a150411l.tp_addr