/* Formatted on 24/02/2014 15:30:32 (QP5 v5.227.12220.39724) */
  SELECT a1402zv.tab_num,
         st.fio fio_ts,
         a1402zv.fio_eta,
         a1402zv.tp_ur,
         a1402zv.tp_addr,
         a1402zv.tp_kod,
         a1402zvtps.contact_lpr,
         a1402zv.ttabc
    FROM a1402zv_tp_select a1402zvtps, a1402zv, user_list st
   WHERE     a1402zv.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1402zv.tp_kod = a1402zvtps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a1402zv.h_fio_eta, :eta_list) =
                a1402zv.h_fio_eta
GROUP BY a1402zv.tab_num,
         st.fio,
         a1402zv.fio_eta,
         a1402zv.tp_ur,
         a1402zv.tp_addr,
         a1402zv.tp_kod,
         a1402zvtps.contact_lpr,
         a1402zv.ttabc
ORDER BY st.fio,
         a1402zv.fio_eta,
         a1402zv.tp_ur,
         a1402zv.tp_addr