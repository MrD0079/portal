/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1610s7.tab_num,
         st.fio fio_ts,
         a1610s7.fio_eta,
         a1610s7.tp_ur,
         a1610s7.tp_addr,
         a1610s7.tp_kod,
         a1610s7tps.contact_lpr
    FROM a1610s7_tp_select a1610s7tps, a1610s7, user_list st
   WHERE     a1610s7.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1610s7.tp_kod = a1610s7tps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a1610s7.h_fio_eta, :eta_list) =
                a1610s7.h_fio_eta
GROUP BY a1610s7.tab_num,
         st.fio,
         a1610s7.fio_eta,
         a1610s7.tp_ur,
         a1610s7.tp_addr,
         a1610s7.tp_kod,
         a1610s7tps.contact_lpr
ORDER BY st.fio,
         a1610s7.fio_eta,
         a1610s7.tp_ur,
         a1610s7.tp_addr