/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1711st.tab_num,
         st.fio fio_ts,
         a1711st.fio_eta,
         a1711st.tp_ur,
         a1711st.tp_addr,
         a1711st.tp_kod,
         a1711sttps.contact_lpr
    FROM a1711st_tp_select a1711sttps, a1711st, user_list st
   WHERE     a1711st.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1711st.tp_kod = a1711sttps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1711st.h_fio_eta, :eta_list) =
                a1711st.h_fio_eta
GROUP BY a1711st.tab_num,
         st.fio,
         a1711st.fio_eta,
         a1711st.tp_ur,
         a1711st.tp_addr,
         a1711st.tp_kod,
         a1711sttps.contact_lpr
ORDER BY st.fio,
         a1711st.fio_eta,
         a1711st.tp_ur,
         a1711st.tp_addr