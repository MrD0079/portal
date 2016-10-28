/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1608rz.tab_num,
         st.fio fio_ts,
         a1608rz.fio_eta,
         a1608rz.tp_ur,
         a1608rz.tp_addr,
         a1608rz.tp_kod,
         a1608rztps.contact_lpr
    FROM a1608rz_tp_select a1608rztps, a1608rz, user_list st
   WHERE     a1608rz.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1608rz.tp_kod = a1608rztps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a1608rz.h_fio_eta, :eta_list) =
                a1608rz.h_fio_eta
GROUP BY a1608rz.tab_num,
         st.fio,
         a1608rz.fio_eta,
         a1608rz.tp_ur,
         a1608rz.tp_addr,
         a1608rz.tp_kod,
         a1608rztps.contact_lpr
ORDER BY st.fio,
         a1608rz.fio_eta,
         a1608rz.tp_ur,
         a1608rz.tp_addr