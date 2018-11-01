/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1809ot.tab_num,
         st.fio fio_ts,
         a1809ot.fio_eta,
         a1809ot.tp_ur,
         a1809ot.tp_addr,
         a1809ot.tp_kod,
         a1809ottps.contact_lpr
    FROM a1809ot_tp_select a1809ottps, a1809ot, user_list st
   WHERE     a1809ot.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1809ot.tp_kod = a1809ottps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1809ot.h_fio_eta, :eta_list) =
                a1809ot.h_fio_eta
GROUP BY a1809ot.tab_num,
         st.fio,
         a1809ot.fio_eta,
         a1809ot.tp_ur,
         a1809ot.tp_addr,
         a1809ot.tp_kod,
         a1809ottps.contact_lpr
ORDER BY st.fio,
         a1809ot.fio_eta,
         a1809ot.tp_ur,
         a1809ot.tp_addr