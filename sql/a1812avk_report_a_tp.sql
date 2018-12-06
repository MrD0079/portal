/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1812avk.tab_num,
         st.fio fio_ts,
         a1812avk.fio_eta,
         a1812avk.tp_ur,
         a1812avk.tp_addr,
         a1812avk.tp_kod,
         a1812avktps.contact_lpr
    FROM a1812avk_tp_select a1812avktps, a1812avk, user_list st
   WHERE     a1812avk.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1812avk.tp_kod = a1812avktps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1812avk.h_fio_eta, :eta_list) =
                a1812avk.h_fio_eta
GROUP BY a1812avk.tab_num,
         st.fio,
         a1812avk.fio_eta,
         a1812avk.tp_ur,
         a1812avk.tp_addr,
         a1812avk.tp_kod,
         a1812avktps.contact_lpr
ORDER BY st.fio,
         a1812avk.fio_eta,
         a1812avk.tp_ur,
         a1812avk.tp_addr