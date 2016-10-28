/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1606ls.tab_num,
         st.fio fio_ts,
         a1606ls.fio_eta,
         a1606ls.tp_ur,
         a1606ls.tp_addr,
         a1606ls.tp_kod,
         a1606lstps.contact_lpr
    FROM a1606ls_tp_select a1606lstps, a1606ls, user_list st
   WHERE     a1606ls.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1606ls.tp_kod = a1606lstps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a1606ls.h_fio_eta, :eta_list) =
                a1606ls.h_fio_eta
GROUP BY a1606ls.tab_num,
         st.fio,
         a1606ls.fio_eta,
         a1606ls.tp_ur,
         a1606ls.tp_addr,
         a1606ls.tp_kod,
         a1606lstps.contact_lpr
ORDER BY st.fio,
         a1606ls.fio_eta,
         a1606ls.tp_ur,
         a1606ls.tp_addr