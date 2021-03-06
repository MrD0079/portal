/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a150211kru.tab_num,
         st.fio fio_ts,
         a150211kru.fio_eta,
         a150211kru.tp_ur,
         a150211kru.tp_addr,
         a150211kru.tp_kod,
         a150211krutps.contact_lpr
    FROM a150211kru_tp_select a150211krutps, a150211kru, user_list st
   WHERE     a150211kru.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a150211kru.tp_kod = a150211krutps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a150211kru.h_fio_eta, :eta_list) =
                a150211kru.h_fio_eta
GROUP BY a150211kru.tab_num,
         st.fio,
         a150211kru.fio_eta,
         a150211kru.tp_ur,
         a150211kru.tp_addr,
         a150211kru.tp_kod,
         a150211krutps.contact_lpr
ORDER BY st.fio,
         a150211kru.fio_eta,
         a150211kru.tp_ur,
         a150211kru.tp_addr