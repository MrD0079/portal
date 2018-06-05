/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1806sb3.tab_num,
         st.fio fio_ts,
         a1806sb3.fio_eta,
         a1806sb3.tp_ur,
         a1806sb3.tp_addr,
         a1806sb3.tp_kod,
         a1806sb3tps.contact_lpr
    FROM a1806sb3_tp_select a1806sb3tps, a1806sb3, user_list st
   WHERE     a1806sb3.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1806sb3.tp_kod = a1806sb3tps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1806sb3.h_fio_eta, :eta_list) =
                a1806sb3.h_fio_eta
GROUP BY a1806sb3.tab_num,
         st.fio,
         a1806sb3.fio_eta,
         a1806sb3.tp_ur,
         a1806sb3.tp_addr,
         a1806sb3.tp_kod,
         a1806sb3tps.contact_lpr
ORDER BY st.fio,
         a1806sb3.fio_eta,
         a1806sb3.tp_ur,
         a1806sb3.tp_addr