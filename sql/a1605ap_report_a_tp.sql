/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1605ap.tab_num,
         st.fio fio_ts,
         a1605ap.fio_eta,
         a1605ap.tp_ur,
         a1605ap.tp_addr,
         a1605ap.tp_kod,
         a1605aptps.contact_lpr
    FROM a1605ap_tp_select a1605aptps, a1605ap, user_list st
   WHERE     a1605ap.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1605ap.tp_kod = a1605aptps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1605ap.h_fio_eta, :eta_list) =
                a1605ap.h_fio_eta
GROUP BY a1605ap.tab_num,
         st.fio,
         a1605ap.fio_eta,
         a1605ap.tp_ur,
         a1605ap.tp_addr,
         a1605ap.tp_kod,
         a1605aptps.contact_lpr
ORDER BY st.fio,
         a1605ap.fio_eta,
         a1605ap.tp_ur,
         a1605ap.tp_addr