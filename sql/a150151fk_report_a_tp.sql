/* Formatted on 26/03/2015 17:15:26 (QP5 v5.227.12220.39724) */
  SELECT t1.tab_num,
         st.fio fio_ts,
         t1.fio_eta,
         t1.tp_ur,
         t1.tp_addr,
         t1.tp_kod,
         tp.contact_lpr
    FROM a150151fk_tp_select tp, a150151fk t1, user_list st
   WHERE     t1.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND t1.tp_kod = tp.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', t1.h_fio_eta, :eta_list) = t1.h_fio_eta
GROUP BY t1.tab_num,
         st.fio,
         t1.fio_eta,
         t1.tp_ur,
         t1.tp_addr,
         t1.tp_kod,
         tp.contact_lpr
ORDER BY st.fio,
         t1.fio_eta,
         t1.tp_ur,
         t1.tp_addr