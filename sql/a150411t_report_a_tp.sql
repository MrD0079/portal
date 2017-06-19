/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a150411t.tab_num,
         st.fio fio_ts,
         a150411t.fio_eta,
         a150411t.tp_ur,
         a150411t.tp_addr,
         a150411t.tp_kod,
         a150411ttps.contact_lpr
    FROM a150411t_tp_select a150411ttps, a150411t, user_list st
   WHERE     a150411t.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a150411t.tp_kod = a150411ttps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a150411t.h_fio_eta, :eta_list) =
                a150411t.h_fio_eta
GROUP BY a150411t.tab_num,
         st.fio,
         a150411t.fio_eta,
         a150411t.tp_ur,
         a150411t.tp_addr,
         a150411t.tp_kod,
         a150411ttps.contact_lpr
ORDER BY st.fio,
         a150411t.fio_eta,
         a150411t.tp_ur,
         a150411t.tp_addr