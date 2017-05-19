/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1705uk.tab_num,
         st.fio fio_ts,
         a1705uk.fio_eta,
         a1705uk.tp_ur,
         a1705uk.tp_addr,
         a1705uk.tp_kod,
         a1705uktps.contact_lpr
    FROM a1705uk_tp_select a1705uktps, a1705uk, user_list st
   WHERE     a1705uk.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1705uk.tp_kod = a1705uktps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a1705uk.h_fio_eta, :eta_list) =
                a1705uk.h_fio_eta
GROUP BY a1705uk.tab_num,
         st.fio,
         a1705uk.fio_eta,
         a1705uk.tp_ur,
         a1705uk.tp_addr,
         a1705uk.tp_kod,
         a1705uktps.contact_lpr
ORDER BY st.fio,
         a1705uk.fio_eta,
         a1705uk.tp_ur,
         a1705uk.tp_addr