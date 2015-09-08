/* Formatted on 24.01.2014 16:31:15 (QP5 v5.227.12220.39724) */
  SELECT a1403cp.tab_num,
         st.fio fio_ts,
         a1403cp.fio_eta,
         a1403cp.tp_ur,
         a1403cp.tp_addr,
         a1403cp.tp_kod,
         a1403cptps.contact_lpr
    FROM a1403cp_tp_select a1403cptps, a1403cp, user_list st
   WHERE     a1403cp.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1403cp.tp_kod = a1403cptps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a1403cp.h_fio_eta, :eta_list) =
                a1403cp.h_fio_eta
GROUP BY a1403cp.tab_num,
         st.fio,
         a1403cp.fio_eta,
         a1403cp.tp_ur,
         a1403cp.tp_addr,
         a1403cp.tp_kod,
         a1403cptps.contact_lpr
ORDER BY st.fio,
         a1403cp.fio_eta,
         a1403cp.tp_ur,
         a1403cp.tp_addr