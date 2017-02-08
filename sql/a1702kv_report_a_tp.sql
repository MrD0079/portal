/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1702kv.tab_num,
         st.fio fio_ts,
         a1702kv.fio_eta,
         a1702kv.tp_ur,
         a1702kv.tp_addr,
         a1702kv.tp_kod,
         a1702kvtps.contact_lpr
    FROM a1702kv_tp_select a1702kvtps, a1702kv, user_list st
   WHERE     a1702kv.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1702kv.tp_kod = a1702kvtps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a1702kv.h_fio_eta, :eta_list) =
                a1702kv.h_fio_eta
GROUP BY a1702kv.tab_num,
         st.fio,
         a1702kv.fio_eta,
         a1702kv.tp_ur,
         a1702kv.tp_addr,
         a1702kv.tp_kod,
         a1702kvtps.contact_lpr
ORDER BY st.fio,
         a1702kv.fio_eta,
         a1702kv.tp_ur,
         a1702kv.tp_addr