/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1811obc.tab_num,
         st.fio fio_ts,
         a1811obc.fio_eta,
         a1811obc.tp_ur,
         a1811obc.tp_addr,
         a1811obc.tp_kod,
         a1811obctps.contact_lpr
    FROM a1811obc_tp_select a1811obctps, a1811obc, user_list st
   WHERE     a1811obc.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1811obc.tp_kod = a1811obctps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1811obc.h_fio_eta, :eta_list) =
                a1811obc.h_fio_eta
GROUP BY a1811obc.tab_num,
         st.fio,
         a1811obc.fio_eta,
         a1811obc.tp_ur,
         a1811obc.tp_addr,
         a1811obc.tp_kod,
         a1811obctps.contact_lpr
ORDER BY st.fio,
         a1811obc.fio_eta,
         a1811obc.tp_ur,
         a1811obc.tp_addr