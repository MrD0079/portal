/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1908ref.tab_num,
         st.fio fio_ts,
         a1908ref.fio_eta,
         a1908ref.tp_ur,
         a1908ref.tp_addr,
         a1908ref.tp_kod,
         a1908reftps.contact_lpr
    FROM a1908ref_tp_select a1908reftps, a1908ref, user_list st
   WHERE     a1908ref.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1908ref.tp_kod = a1908reftps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1908ref.h_fio_eta, :eta_list) =
                a1908ref.h_fio_eta
GROUP BY a1908ref.tab_num,
         st.fio,
         a1908ref.fio_eta,
         a1908ref.tp_ur,
         a1908ref.tp_addr,
         a1908ref.tp_kod,
         a1908reftps.contact_lpr
ORDER BY st.fio,
         a1908ref.fio_eta,
         a1908ref.tp_ur,
         a1908ref.tp_addr