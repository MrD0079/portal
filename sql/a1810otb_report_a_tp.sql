/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1810otb.tab_num,
         st.fio fio_ts,
         a1810otb.fio_eta,
         a1810otb.tp_ur,
         a1810otb.tp_addr,
         a1810otb.tp_kod,
         a1810otbtps.contact_lpr
    FROM a1810otb_tp_select a1810otbtps, a1810otb, user_list st
   WHERE     a1810otb.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1810otb.tp_kod = a1810otbtps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1810otb.h_fio_eta, :eta_list) =
                a1810otb.h_fio_eta
GROUP BY a1810otb.tab_num,
         st.fio,
         a1810otb.fio_eta,
         a1810otb.tp_ur,
         a1810otb.tp_addr,
         a1810otb.tp_kod,
         a1810otbtps.contact_lpr
ORDER BY st.fio,
         a1810otb.fio_eta,
         a1810otb.tp_ur,
         a1810otb.tp_addr