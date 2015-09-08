/* Formatted on 24.01.2014 16:31:15 (QP5 v5.227.12220.39724) */
  SELECT a1406b.tab_num,
         st.fio fio_ts,
         a1406b.fio_eta,
         a1406b.tp_ur,
         a1406b.tp_addr,
         a1406b.tp_kod,
         a1406btps.contact_lpr
    FROM a1406b_tp_select a1406btps, a1406b, user_list st
   WHERE     a1406b.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1406b.tp_kod = a1406btps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a1406b.h_fio_eta, :eta_list) =
                a1406b.h_fio_eta
GROUP BY a1406b.tab_num,
         st.fio,
         a1406b.fio_eta,
         a1406b.tp_ur,
         a1406b.tp_addr,
         a1406b.tp_kod,
         a1406btps.contact_lpr
ORDER BY st.fio,
         a1406b.fio_eta,
         a1406b.tp_ur,
         a1406b.tp_addr