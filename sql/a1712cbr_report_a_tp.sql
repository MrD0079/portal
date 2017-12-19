/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1712cbr.tab_num,
         st.fio fio_ts,
         a1712cbr.fio_eta,
         a1712cbr.tp_ur,
         a1712cbr.tp_addr,
         a1712cbr.tp_kod,
         a1712cbrtps.contact_lpr
    FROM a1712cbr_tp_select a1712cbrtps, a1712cbr, user_list st
   WHERE     a1712cbr.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1712cbr.tp_kod = a1712cbrtps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1712cbr.h_fio_eta, :eta_list) =
                a1712cbr.h_fio_eta
GROUP BY a1712cbr.tab_num,
         st.fio,
         a1712cbr.fio_eta,
         a1712cbr.tp_ur,
         a1712cbr.tp_addr,
         a1712cbr.tp_kod,
         a1712cbrtps.contact_lpr
ORDER BY st.fio,
         a1712cbr.fio_eta,
         a1712cbr.tp_ur,
         a1712cbr.tp_addr