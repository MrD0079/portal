/* Formatted on 26/11/2014 17:29:25 (QP5 v5.227.12220.39724) */
  SELECT a1411z.tab_num,
         st.fio fio_ts,
         a1411z.fio_eta,
         a1411z.tp_ur,
         a1411z.tp_addr,
         a1411z.tp_kod_key,
         a1411ztps.contact_lpr
    FROM a1411z_tp_select a1411ztps, a1411z, user_list st
   WHERE     a1411z.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1411z.tp_kod_key = a1411ztps.tp_kod_key
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a1411z.h_fio_eta, :eta_list) =
                a1411z.h_fio_eta
GROUP BY a1411z.tab_num,
         st.fio,
         a1411z.fio_eta,
         a1411z.tp_ur,
         a1411z.tp_addr,
         a1411z.tp_kod_key,
         a1411ztps.contact_lpr
ORDER BY st.fio,
         a1411z.fio_eta,
         a1411z.tp_ur,
         a1411z.tp_addr