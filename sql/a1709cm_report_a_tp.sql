/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1709cm.tab_num,
         st.fio fio_ts,
         a1709cm.fio_eta,
         a1709cm.tp_ur,
         a1709cm.tp_addr,
         a1709cm.tp_kod,
         a1709cmtps.contact_lpr
    FROM a1709cm_tp_select a1709cmtps, a1709cm, user_list st
   WHERE     a1709cm.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1709cm.tp_kod = a1709cmtps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1709cm.h_fio_eta, :eta_list) =
                a1709cm.h_fio_eta
GROUP BY a1709cm.tab_num,
         st.fio,
         a1709cm.fio_eta,
         a1709cm.tp_ur,
         a1709cm.tp_addr,
         a1709cm.tp_kod,
         a1709cmtps.contact_lpr
ORDER BY st.fio,
         a1709cm.fio_eta,
         a1709cm.tp_ur,
         a1709cm.tp_addr