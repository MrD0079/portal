/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1706sc.tab_num,
         st.fio fio_ts,
         a1706sc.fio_eta,
         a1706sc.tp_ur,
         a1706sc.tp_addr,
         a1706sc.tp_kod,
         a1706sctps.contact_lpr
    FROM a1706sc_tp_select a1706sctps, a1706sc, user_list st
   WHERE     a1706sc.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1706sc.tp_kod = a1706sctps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1706sc.h_fio_eta, :eta_list) =
                a1706sc.h_fio_eta
GROUP BY a1706sc.tab_num,
         st.fio,
         a1706sc.fio_eta,
         a1706sc.tp_ur,
         a1706sc.tp_addr,
         a1706sc.tp_kod,
         a1706sctps.contact_lpr
ORDER BY st.fio,
         a1706sc.fio_eta,
         a1706sc.tp_ur,
         a1706sc.tp_addr