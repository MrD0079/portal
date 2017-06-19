/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1701ks.tab_num,
         st.fio fio_ts,
         a1701ks.fio_eta,
         a1701ks.tp_ur,
         a1701ks.tp_addr,
         a1701ks.tp_kod,
         a1701kstps.contact_lpr
    FROM a1701ks_tp_select a1701kstps, a1701ks, user_list st
   WHERE     a1701ks.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1701ks.tp_kod = a1701kstps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1701ks.h_fio_eta, :eta_list) =
                a1701ks.h_fio_eta
GROUP BY a1701ks.tab_num,
         st.fio,
         a1701ks.fio_eta,
         a1701ks.tp_ur,
         a1701ks.tp_addr,
         a1701ks.tp_kod,
         a1701kstps.contact_lpr
ORDER BY st.fio,
         a1701ks.fio_eta,
         a1701ks.tp_ur,
         a1701ks.tp_addr