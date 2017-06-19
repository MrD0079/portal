/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a150221ngs.tab_num,
         st.fio fio_ts,
         a150221ngs.fio_eta,
         a150221ngs.tp_ur,
         a150221ngs.tp_addr,
         a150221ngs.tp_kod,
         a150221ngstps.contact_lpr
    FROM a150221ngs_tp_select a150221ngstps, a150221ngs, user_list st
   WHERE     a150221ngs.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a150221ngs.tp_kod = a150221ngstps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a150221ngs.h_fio_eta, :eta_list) =
                a150221ngs.h_fio_eta
GROUP BY a150221ngs.tab_num,
         st.fio,
         a150221ngs.fio_eta,
         a150221ngs.tp_ur,
         a150221ngs.tp_addr,
         a150221ngs.tp_kod,
         a150221ngstps.contact_lpr
ORDER BY st.fio,
         a150221ngs.fio_eta,
         a150221ngs.tp_ur,
         a150221ngs.tp_addr