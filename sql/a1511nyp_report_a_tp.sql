/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1511nyp.tab_num,
         st.fio fio_ts,
         a1511nyp.fio_eta,
         a1511nyp.tp_ur,
         a1511nyp.tp_addr,
         a1511nyp.tp_kod,
         a1511nyptps.contact_lpr
    FROM a1511nyp_tp_select a1511nyptps, a1511nyp, user_list st
   WHERE     a1511nyp.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1511nyp.tp_kod = a1511nyptps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1511nyp.h_fio_eta, :eta_list) =
                a1511nyp.h_fio_eta
GROUP BY a1511nyp.tab_num,
         st.fio,
         a1511nyp.fio_eta,
         a1511nyp.tp_ur,
         a1511nyp.tp_addr,
         a1511nyp.tp_kod,
         a1511nyptps.contact_lpr
ORDER BY st.fio,
         a1511nyp.fio_eta,
         a1511nyp.tp_ur,
         a1511nyp.tp_addr