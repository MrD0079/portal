/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1702kvv.tab_num,
         st.fio fio_ts,
         a1702kvv.fio_eta,
         a1702kvv.tp_ur,
         a1702kvv.tp_addr,
         a1702kvv.tp_kod,
         a1702kvvtps.contact_lpr
    FROM a1702kvv_tp_select a1702kvvtps, a1702kvv, user_list st
   WHERE     a1702kvv.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1702kvv.tp_kod = a1702kvvtps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1702kvv.h_fio_eta, :eta_list) =
                a1702kvv.h_fio_eta
GROUP BY a1702kvv.tab_num,
         st.fio,
         a1702kvv.fio_eta,
         a1702kvv.tp_ur,
         a1702kvv.tp_addr,
         a1702kvv.tp_kod,
         a1702kvvtps.contact_lpr
ORDER BY st.fio,
         a1702kvv.fio_eta,
         a1702kvv.tp_ur,
         a1702kvv.tp_addr