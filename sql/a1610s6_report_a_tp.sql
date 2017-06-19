/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1610s6.tab_num,
         st.fio fio_ts,
         a1610s6.fio_eta,
         a1610s6.tp_ur,
         a1610s6.tp_addr,
         a1610s6.tp_kod,
         a1610s6tps.contact_lpr
    FROM a1610s6_tp_select a1610s6tps, a1610s6, user_list st
   WHERE     a1610s6.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1610s6.tp_kod = a1610s6tps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1610s6.h_fio_eta, :eta_list) =
                a1610s6.h_fio_eta
GROUP BY a1610s6.tab_num,
         st.fio,
         a1610s6.fio_eta,
         a1610s6.tp_ur,
         a1610s6.tp_addr,
         a1610s6.tp_kod,
         a1610s6tps.contact_lpr
ORDER BY st.fio,
         a1610s6.fio_eta,
         a1610s6.tp_ur,
         a1610s6.tp_addr