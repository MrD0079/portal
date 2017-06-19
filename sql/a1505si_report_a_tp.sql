/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1505si.tab_num,
         st.fio fio_ts,
         a1505si.fio_eta,
         a1505si.tp_ur,
         a1505si.tp_addr,
         a1505si.tp_kod,
         a1505sitps.contact_lpr
    FROM a1505si_tp_select a1505sitps, a1505si, user_list st
   WHERE     a1505si.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1505si.tp_kod = a1505sitps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1505si.h_fio_eta, :eta_list) =
                a1505si.h_fio_eta
GROUP BY a1505si.tab_num,
         st.fio,
         a1505si.fio_eta,
         a1505si.tp_ur,
         a1505si.tp_addr,
         a1505si.tp_kod,
         a1505sitps.contact_lpr
ORDER BY st.fio,
         a1505si.fio_eta,
         a1505si.tp_ur,
         a1505si.tp_addr