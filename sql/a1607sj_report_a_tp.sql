/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1607sj.tab_num,
         st.fio fio_ts,
         a1607sj.fio_eta,
         a1607sj.tp_ur,
         a1607sj.tp_addr,
         a1607sj.tp_kod,
         a1607sjtps.contact_lpr
    FROM a1607sj_tp_select a1607sjtps, a1607sj, user_list st
   WHERE     a1607sj.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1607sj.tp_kod = a1607sjtps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a1607sj.h_fio_eta, :eta_list) =
                a1607sj.h_fio_eta
GROUP BY a1607sj.tab_num,
         st.fio,
         a1607sj.fio_eta,
         a1607sj.tp_ur,
         a1607sj.tp_addr,
         a1607sj.tp_kod,
         a1607sjtps.contact_lpr
ORDER BY st.fio,
         a1607sj.fio_eta,
         a1607sj.tp_ur,
         a1607sj.tp_addr