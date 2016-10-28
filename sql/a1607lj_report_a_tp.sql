/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1607lj.tab_num,
         st.fio fio_ts,
         a1607lj.fio_eta,
         a1607lj.tp_ur,
         a1607lj.tp_addr,
         a1607lj.tp_kod,
         a1607ljtps.contact_lpr
    FROM a1607lj_tp_select a1607ljtps, a1607lj, user_list st
   WHERE     a1607lj.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1607lj.tp_kod = a1607ljtps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a1607lj.h_fio_eta, :eta_list) =
                a1607lj.h_fio_eta
GROUP BY a1607lj.tab_num,
         st.fio,
         a1607lj.fio_eta,
         a1607lj.tp_ur,
         a1607lj.tp_addr,
         a1607lj.tp_kod,
         a1607ljtps.contact_lpr
ORDER BY st.fio,
         a1607lj.fio_eta,
         a1607lj.tp_ur,
         a1607lj.tp_addr