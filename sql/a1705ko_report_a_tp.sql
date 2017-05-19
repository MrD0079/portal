/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1705ko.tab_num,
         st.fio fio_ts,
         a1705ko.fio_eta,
         a1705ko.tp_ur,
         a1705ko.tp_addr,
         a1705ko.tp_kod,
         a1705kotps.contact_lpr
    FROM a1705ko_tp_select a1705kotps, a1705ko, user_list st
   WHERE     a1705ko.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1705ko.tp_kod = a1705kotps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a1705ko.h_fio_eta, :eta_list) =
                a1705ko.h_fio_eta
GROUP BY a1705ko.tab_num,
         st.fio,
         a1705ko.fio_eta,
         a1705ko.tp_ur,
         a1705ko.tp_addr,
         a1705ko.tp_kod,
         a1705kotps.contact_lpr
ORDER BY st.fio,
         a1705ko.fio_eta,
         a1705ko.tp_ur,
         a1705ko.tp_addr