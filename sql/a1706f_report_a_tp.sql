/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1706f.tab_num,
         st.fio fio_ts,
         a1706f.fio_eta,
         a1706f.tp_ur,
         a1706f.tp_addr,
         a1706f.tp_kod,
         a1706ftps.contact_lpr
    FROM a1706f_tp_select a1706ftps, a1706f, user_list st
   WHERE     a1706f.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1706f.tp_kod = a1706ftps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1706f.h_fio_eta, :eta_list) =
                a1706f.h_fio_eta
GROUP BY a1706f.tab_num,
         st.fio,
         a1706f.fio_eta,
         a1706f.tp_ur,
         a1706f.tp_addr,
         a1706f.tp_kod,
         a1706ftps.contact_lpr
ORDER BY st.fio,
         a1706f.fio_eta,
         a1706f.tp_ur,
         a1706f.tp_addr