/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1608cs.tab_num,
         st.fio fio_ts,
         a1608cs.fio_eta,
         a1608cs.tp_ur,
         a1608cs.tp_addr,
         a1608cs.tp_kod,
         a1608cstps.contact_lpr
    FROM a1608cs_tp_select a1608cstps, a1608cs, user_list st
   WHERE     a1608cs.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1608cs.tp_kod = a1608cstps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1608cs.h_fio_eta, :eta_list) =
                a1608cs.h_fio_eta
GROUP BY a1608cs.tab_num,
         st.fio,
         a1608cs.fio_eta,
         a1608cs.tp_ur,
         a1608cs.tp_addr,
         a1608cs.tp_kod,
         a1608cstps.contact_lpr
ORDER BY st.fio,
         a1608cs.fio_eta,
         a1608cs.tp_ur,
         a1608cs.tp_addr