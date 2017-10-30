/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1710cc.tab_num,
         st.fio fio_ts,
         a1710cc.fio_eta,
         a1710cc.tp_ur,
         a1710cc.tp_addr,
         a1710cc.tp_kod,
         a1710cctps.contact_lpr
    FROM a1710cc_tp_select a1710cctps, a1710cc, user_list st
   WHERE     a1710cc.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1710cc.tp_kod = a1710cctps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1710cc.h_fio_eta, :eta_list) =
                a1710cc.h_fio_eta
GROUP BY a1710cc.tab_num,
         st.fio,
         a1710cc.fio_eta,
         a1710cc.tp_ur,
         a1710cc.tp_addr,
         a1710cc.tp_kod,
         a1710cctps.contact_lpr
ORDER BY st.fio,
         a1710cc.fio_eta,
         a1710cc.tp_ur,
         a1710cc.tp_addr