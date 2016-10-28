/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1512nyp.tab_num,
         st.fio fio_ts,
         a1512nyp.fio_eta,
         a1512nyp.tp_ur,
         a1512nyp.tp_addr,
         a1512nyp.tp_kod,
         a1512nyptps.contact_lpr
    FROM a1512nyp_tp_select a1512nyptps, a1512nyp, user_list st
   WHERE     a1512nyp.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1512nyp.tp_kod = a1512nyptps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a1512nyp.h_fio_eta, :eta_list) =
                a1512nyp.h_fio_eta
GROUP BY a1512nyp.tab_num,
         st.fio,
         a1512nyp.fio_eta,
         a1512nyp.tp_ur,
         a1512nyp.tp_addr,
         a1512nyp.tp_kod,
         a1512nyptps.contact_lpr
ORDER BY st.fio,
         a1512nyp.fio_eta,
         a1512nyp.tp_ur,
         a1512nyp.tp_addr