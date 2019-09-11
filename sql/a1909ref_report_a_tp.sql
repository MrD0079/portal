/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1909ref.tab_num,
         st.fio fio_ts,
         a1909ref.fio_eta,
         a1909ref.tp_ur,
         a1909ref.tp_addr,
         a1909ref.tp_kod,
         a1909reftps.contact_lpr
    FROM a1909ref_tp_select a1909reftps, a1909ref, user_list st
   WHERE     a1909ref.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1909ref.tp_kod = a1909reftps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1909ref.h_fio_eta, :eta_list) =
                a1909ref.h_fio_eta
GROUP BY a1909ref.tab_num,
         st.fio,
         a1909ref.fio_eta,
         a1909ref.tp_ur,
         a1909ref.tp_addr,
         a1909ref.tp_kod,
         a1909reftps.contact_lpr
ORDER BY st.fio,
         a1909ref.fio_eta,
         a1909ref.tp_ur,
         a1909ref.tp_addr