/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1606lg.tab_num,
         st.fio fio_ts,
         a1606lg.fio_eta,
         a1606lg.tp_ur,
         a1606lg.tp_addr,
         a1606lg.tp_kod,
         a1606lgtps.contact_lpr
    FROM a1606lg_tp_select a1606lgtps, a1606lg, user_list st
   WHERE     a1606lg.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1606lg.tp_kod = a1606lgtps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1606lg.h_fio_eta, :eta_list) =
                a1606lg.h_fio_eta
GROUP BY a1606lg.tab_num,
         st.fio,
         a1606lg.fio_eta,
         a1606lg.tp_ur,
         a1606lg.tp_addr,
         a1606lg.tp_kod,
         a1606lgtps.contact_lpr
ORDER BY st.fio,
         a1606lg.fio_eta,
         a1606lg.tp_ur,
         a1606lg.tp_addr