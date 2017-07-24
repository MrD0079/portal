/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1707hi.tab_num,
         st.fio fio_ts,
         a1707hi.fio_eta,
         a1707hi.tp_ur,
         a1707hi.tp_addr,
         a1707hi.tp_kod,
         a1707hitps.contact_lpr
    FROM a1707hi_tp_select a1707hitps, a1707hi, user_list st
   WHERE     a1707hi.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1707hi.tp_kod = a1707hitps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1707hi.h_fio_eta, :eta_list) =
                a1707hi.h_fio_eta
GROUP BY a1707hi.tab_num,
         st.fio,
         a1707hi.fio_eta,
         a1707hi.tp_ur,
         a1707hi.tp_addr,
         a1707hi.tp_kod,
         a1707hitps.contact_lpr
ORDER BY st.fio,
         a1707hi.fio_eta,
         a1707hi.tp_ur,
         a1707hi.tp_addr