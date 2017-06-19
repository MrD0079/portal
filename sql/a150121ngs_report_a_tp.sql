/* Formatted on 26/03/2015 17:15:19 (QP5 v5.227.12220.39724) */
  SELECT a150121ngs.tab_num,
         st.fio fio_ts,
         a150121ngs.fio_eta,
         a150121ngs.tp_ur,
         a150121ngs.tp_addr,
         a150121ngs.tp_kod,
         a150121ngstps.contact_lpr
    FROM a150121ngs_tp_select a150121ngstps, a150121ngs, user_list st
   WHERE     a150121ngs.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a150121ngs.tp_kod = a150121ngstps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a150121ngs.h_fio_eta, :eta_list) =
                a150121ngs.h_fio_eta
GROUP BY a150121ngs.tab_num,
         st.fio,
         a150121ngs.fio_eta,
         a150121ngs.tp_ur,
         a150121ngs.tp_addr,
         a150121ngs.tp_kod,
         a150121ngstps.contact_lpr
ORDER BY st.fio,
         a150121ngs.fio_eta,
         a150121ngs.tp_ur,
         a150121ngs.tp_addr