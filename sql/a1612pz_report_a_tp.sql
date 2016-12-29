/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1612pz.tab_num,
         st.fio fio_ts,
         a1612pz.fio_eta,
         a1612pz.tp_ur,
         a1612pz.tp_addr,
         a1612pz.tp_kod,
         a1612pztps.contact_lpr
    FROM a1612pz_tp_select a1612pztps, a1612pz, user_list st
   WHERE     a1612pz.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1612pz.tp_kod = a1612pztps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a1612pz.h_fio_eta, :eta_list) =
                a1612pz.h_fio_eta
GROUP BY a1612pz.tab_num,
         st.fio,
         a1612pz.fio_eta,
         a1612pz.tp_ur,
         a1612pz.tp_addr,
         a1612pz.tp_kod,
         a1612pztps.contact_lpr
ORDER BY st.fio,
         a1612pz.fio_eta,
         a1612pz.tp_ur,
         a1612pz.tp_addr