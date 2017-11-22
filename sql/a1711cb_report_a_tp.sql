/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1711cb.tab_num,
         st.fio fio_ts,
         a1711cb.fio_eta,
         a1711cb.tp_ur,
         a1711cb.tp_addr,
         a1711cb.tp_kod,
         a1711cbtps.contact_lpr
    FROM a1711cb_tp_select a1711cbtps, a1711cb, user_list st
   WHERE     a1711cb.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1711cb.tp_kod = a1711cbtps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1711cb.h_fio_eta, :eta_list) =
                a1711cb.h_fio_eta
GROUP BY a1711cb.tab_num,
         st.fio,
         a1711cb.fio_eta,
         a1711cb.tp_ur,
         a1711cb.tp_addr,
         a1711cb.tp_kod,
         a1711cbtps.contact_lpr
ORDER BY st.fio,
         a1711cb.fio_eta,
         a1711cb.tp_ur,
         a1711cb.tp_addr