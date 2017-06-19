/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1612np.tab_num,
         st.fio fio_ts,
         a1612np.fio_eta,
         a1612np.tp_ur,
         a1612np.tp_addr,
         a1612np.tp_kod,
         a1612nptps.contact_lpr
    FROM a1612np_tp_select a1612nptps, a1612np, user_list st
   WHERE     a1612np.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1612np.tp_kod = a1612nptps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1612np.h_fio_eta, :eta_list) =
                a1612np.h_fio_eta
GROUP BY a1612np.tab_num,
         st.fio,
         a1612np.fio_eta,
         a1612np.tp_ur,
         a1612np.tp_addr,
         a1612np.tp_kod,
         a1612nptps.contact_lpr
ORDER BY st.fio,
         a1612np.fio_eta,
         a1612np.tp_ur,
         a1612np.tp_addr