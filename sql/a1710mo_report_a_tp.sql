/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1710mo.tab_num,
         st.fio fio_ts,
         a1710mo.fio_eta,
         a1710mo.tp_ur,
         a1710mo.tp_addr,
         a1710mo.tp_kod,
         a1710motps.contact_lpr
    FROM a1710mo_tp_select a1710motps, a1710mo, user_list st
   WHERE     a1710mo.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1710mo.tp_kod = a1710motps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1710mo.h_fio_eta, :eta_list) =
                a1710mo.h_fio_eta
GROUP BY a1710mo.tab_num,
         st.fio,
         a1710mo.fio_eta,
         a1710mo.tp_ur,
         a1710mo.tp_addr,
         a1710mo.tp_kod,
         a1710motps.contact_lpr
ORDER BY st.fio,
         a1710mo.fio_eta,
         a1710mo.tp_ur,
         a1710mo.tp_addr