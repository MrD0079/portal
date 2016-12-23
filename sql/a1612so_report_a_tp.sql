/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1612so.tab_num,
         st.fio fio_ts,
         a1612so.fio_eta,
         a1612so.tp_ur,
         a1612so.tp_addr,
         a1612so.tp_kod,
         a1612sotps.contact_lpr
    FROM a1612so_tp_select a1612sotps, a1612so, user_list st
   WHERE     a1612so.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1612so.tp_kod = a1612sotps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a1612so.h_fio_eta, :eta_list) =
                a1612so.h_fio_eta
GROUP BY a1612so.tab_num,
         st.fio,
         a1612so.fio_eta,
         a1612so.tp_ur,
         a1612so.tp_addr,
         a1612so.tp_kod,
         a1612sotps.contact_lpr
ORDER BY st.fio,
         a1612so.fio_eta,
         a1612so.tp_ur,
         a1612so.tp_addr