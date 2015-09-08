/* Formatted on 24.01.2014 16:31:15 (QP5 v5.227.12220.39724) */
  SELECT a1407kr.tab_num,
         st.fio fio_ts,
         a1407kr.fio_eta,
         a1407kr.tp_ur,
         a1407kr.tp_addr,
         a1407kr.tp_kod,
         a1407krtps.contact_lpr
    FROM a1407kr_tp_select a1407krtps, a1407kr, user_list st
   WHERE     a1407kr.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1407kr.tp_kod = a1407krtps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a1407kr.h_fio_eta, :eta_list) =
                a1407kr.h_fio_eta
GROUP BY a1407kr.tab_num,
         st.fio,
         a1407kr.fio_eta,
         a1407kr.tp_ur,
         a1407kr.tp_addr,
         a1407kr.tp_kod,
         a1407krtps.contact_lpr
ORDER BY st.fio,
         a1407kr.fio_eta,
         a1407kr.tp_ur,
         a1407kr.tp_addr