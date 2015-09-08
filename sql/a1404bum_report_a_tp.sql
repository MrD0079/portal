/* Formatted on 24.01.2014 16:31:15 (QP5 v5.227.12220.39724) */
  SELECT a1404bum.tab_num,
         st.fio fio_ts,
         a1404bum.fio_eta,
         a1404bum.tp_ur,
         a1404bum.tp_addr,
         a1404bum.tp_kod,
         a1404bumtps.contact_lpr
    FROM a1404bum_tp_select a1404bumtps, a1404bum, user_list st
   WHERE     a1404bum.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1404bum.tp_kod = a1404bumtps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a1404bum.h_fio_eta, :eta_list) =
                a1404bum.h_fio_eta
GROUP BY a1404bum.tab_num,
         st.fio,
         a1404bum.fio_eta,
         a1404bum.tp_ur,
         a1404bum.tp_addr,
         a1404bum.tp_kod,
         a1404bumtps.contact_lpr
ORDER BY st.fio,
         a1404bum.fio_eta,
         a1404bum.tp_ur,
         a1404bum.tp_addr