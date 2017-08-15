/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1708kb.tab_num,
         st.fio fio_ts,
         a1708kb.fio_eta,
         a1708kb.tp_ur,
         a1708kb.tp_addr,
         a1708kb.tp_kod,
         a1708kbtps.contact_lpr
    FROM a1708kb_tp_select a1708kbtps, a1708kb, user_list st
   WHERE     a1708kb.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1708kb.tp_kod = a1708kbtps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1708kb.h_fio_eta, :eta_list) =
                a1708kb.h_fio_eta
GROUP BY a1708kb.tab_num,
         st.fio,
         a1708kb.fio_eta,
         a1708kb.tp_ur,
         a1708kb.tp_addr,
         a1708kb.tp_kod,
         a1708kbtps.contact_lpr
ORDER BY st.fio,
         a1708kb.fio_eta,
         a1708kb.tp_ur,
         a1708kb.tp_addr