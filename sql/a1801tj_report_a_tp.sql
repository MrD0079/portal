/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1801tj.tab_num,
         st.fio fio_ts,
         a1801tj.fio_eta,
         a1801tj.tp_ur,
         a1801tj.tp_addr,
         a1801tj.tp_kod,
         a1801tjtps.contact_lpr
    FROM a1801tj_tp_select a1801tjtps, a1801tj, user_list st
   WHERE     a1801tj.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1801tj.tp_kod = a1801tjtps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1801tj.h_fio_eta, :eta_list) =
                a1801tj.h_fio_eta
GROUP BY a1801tj.tab_num,
         st.fio,
         a1801tj.fio_eta,
         a1801tj.tp_ur,
         a1801tj.tp_addr,
         a1801tj.tp_kod,
         a1801tjtps.contact_lpr
ORDER BY st.fio,
         a1801tj.fio_eta,
         a1801tj.tp_ur,
         a1801tj.tp_addr