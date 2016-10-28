/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1602kar.tab_num,
         st.fio fio_ts,
         a1602kar.fio_eta,
         a1602kar.tp_ur,
         a1602kar.tp_addr,
         a1602kar.tp_kod,
         a1602kartps.contact_lpr
    FROM a1602kar_tp_select a1602kartps, a1602kar, user_list st
   WHERE     a1602kar.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1602kar.tp_kod = a1602kartps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a1602kar.h_fio_eta, :eta_list) =
                a1602kar.h_fio_eta
GROUP BY a1602kar.tab_num,
         st.fio,
         a1602kar.fio_eta,
         a1602kar.tp_ur,
         a1602kar.tp_addr,
         a1602kar.tp_kod,
         a1602kartps.contact_lpr
ORDER BY st.fio,
         a1602kar.fio_eta,
         a1602kar.tp_ur,
         a1602kar.tp_addr