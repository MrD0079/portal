/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a150511te.tab_num,
         st.fio fio_ts,
         a150511te.fio_eta,
         a150511te.tp_ur,
         a150511te.tp_addr,
         a150511te.tp_kod,
         a150511tetps.contact_lpr
    FROM a150511te_tp_select a150511tetps, a150511te, user_list st
   WHERE     a150511te.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a150511te.tp_kod = a150511tetps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a150511te.h_fio_eta, :eta_list) =
                a150511te.h_fio_eta
GROUP BY a150511te.tab_num,
         st.fio,
         a150511te.fio_eta,
         a150511te.tp_ur,
         a150511te.tp_addr,
         a150511te.tp_kod,
         a150511tetps.contact_lpr
ORDER BY st.fio,
         a150511te.fio_eta,
         a150511te.tp_ur,
         a150511te.tp_addr