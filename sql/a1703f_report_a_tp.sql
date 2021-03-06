/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1703f.tab_num,
         st.fio fio_ts,
         a1703f.fio_eta,
         a1703f.tp_ur,
         a1703f.tp_addr,
         a1703f.tp_kod,
         a1703ftps.contact_lpr
    FROM a1703f_tp_select a1703ftps, a1703f, user_list st
   WHERE     a1703f.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1703f.tp_kod = a1703ftps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1703f.h_fio_eta, :eta_list) =
                a1703f.h_fio_eta
GROUP BY a1703f.tab_num,
         st.fio,
         a1703f.fio_eta,
         a1703f.tp_ur,
         a1703f.tp_addr,
         a1703f.tp_kod,
         a1703ftps.contact_lpr
ORDER BY st.fio,
         a1703f.fio_eta,
         a1703f.tp_ur,
         a1703f.tp_addr