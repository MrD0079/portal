/* Formatted on 24.01.2014 16:31:15 (QP5 v5.227.12220.39724) */
  SELECT a14_oy.tab_num,
         st.fio fio_ts,
         a14_oy.fio_eta,
         a14_oy.tp_ur,
         a14_oy.tp_addr,
         a14_oy.tp_kod,
         a14_oytps.contact_lpr
    FROM a14_oy_tp_select a14_oytps, a14_oy, user_list st
   WHERE     a14_oy.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a14_oy.tp_kod = a14_oytps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a14_oy.h_fio_eta, :eta_list) =
                a14_oy.h_fio_eta
         AND a14_oytps.m = :month
GROUP BY a14_oy.tab_num,
         st.fio,
         a14_oy.fio_eta,
         a14_oy.tp_ur,
         a14_oy.tp_addr,
         a14_oy.tp_kod,
         a14_oytps.contact_lpr
ORDER BY st.fio,
         a14_oy.fio_eta,
         a14_oy.tp_ur,
         a14_oy.tp_addr