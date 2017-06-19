/* Formatted on 26/03/2015 17:15:11 (QP5 v5.227.12220.39724) */
  SELECT a150111ng.tab_num,
         st.fio fio_ts,
         a150111ng.fio_eta,
         a150111ng.tp_ur,
         a150111ng.tp_addr,
         a150111ng.tp_kod,
         a150111ngtps.contact_lpr
    FROM a150111ng_tp_select a150111ngtps, a150111ng, user_list st
   WHERE     a150111ng.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a150111ng.tp_kod = a150111ngtps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a150111ng.h_fio_eta, :eta_list) =
                a150111ng.h_fio_eta
GROUP BY a150111ng.tab_num,
         st.fio,
         a150111ng.fio_eta,
         a150111ng.tp_ur,
         a150111ng.tp_addr,
         a150111ng.tp_kod,
         a150111ngtps.contact_lpr
ORDER BY st.fio,
         a150111ng.fio_eta,
         a150111ng.tp_ur,
         a150111ng.tp_addr