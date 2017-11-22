/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1711es.tab_num,
         st.fio fio_ts,
         a1711es.fio_eta,
         a1711es.tp_ur,
         a1711es.tp_addr,
         a1711es.tp_kod,
         a1711estps.contact_lpr
    FROM a1711es_tp_select a1711estps, a1711es, user_list st
   WHERE     a1711es.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1711es.tp_kod = a1711estps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1711es.h_fio_eta, :eta_list) =
                a1711es.h_fio_eta
GROUP BY a1711es.tab_num,
         st.fio,
         a1711es.fio_eta,
         a1711es.tp_ur,
         a1711es.tp_addr,
         a1711es.tp_kod,
         a1711estps.contact_lpr
ORDER BY st.fio,
         a1711es.fio_eta,
         a1711es.tp_ur,
         a1711es.tp_addr