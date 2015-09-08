/* Formatted on 24.01.2014 16:31:15 (QP5 v5.227.12220.39724) */
  SELECT a1403oy.tab_num,
         st.fio fio_ts,
         a1403oy.fio_eta,
         a1403oy.tp_ur,
         a1403oy.tp_addr,
         a1403oy.tp_kod,
         a1403oytps.contact_lpr
    FROM a1403oy_tp_select a1403oytps, a1403oy, user_list st
   WHERE     a1403oy.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1403oy.tp_kod = a1403oytps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a1403oy.h_fio_eta, :eta_list) =
                a1403oy.h_fio_eta
GROUP BY a1403oy.tab_num,
         st.fio,
         a1403oy.fio_eta,
         a1403oy.tp_ur,
         a1403oy.tp_addr,
         a1403oy.tp_kod,
         a1403oytps.contact_lpr
ORDER BY st.fio,
         a1403oy.fio_eta,
         a1403oy.tp_ur,
         a1403oy.tp_addr