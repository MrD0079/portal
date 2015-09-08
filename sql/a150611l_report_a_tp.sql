/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a150611l.tab_num,
         st.fio fio_ts,
         a150611l.fio_eta,
         a150611l.tp_ur,
         a150611l.tp_addr,
         a150611l.tp_kod,
         a150611ltps.contact_lpr
    FROM a150611l_tp_select a150611ltps, a150611l, user_list st
   WHERE     a150611l.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a150611l.tp_kod = a150611ltps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a150611l.h_fio_eta, :eta_list) =
                a150611l.h_fio_eta
GROUP BY a150611l.tab_num,
         st.fio,
         a150611l.fio_eta,
         a150611l.tp_ur,
         a150611l.tp_addr,
         a150611l.tp_kod,
         a150611ltps.contact_lpr
ORDER BY st.fio,
         a150611l.fio_eta,
         a150611l.tp_ur,
         a150611l.tp_addr