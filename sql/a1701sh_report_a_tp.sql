/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1701sh.tab_num,
         st.fio fio_ts,
         a1701sh.fio_eta,
         a1701sh.tp_ur,
         a1701sh.tp_addr,
         a1701sh.tp_kod,
         a1701shtps.contact_lpr
    FROM a1701sh_tp_select a1701shtps, a1701sh, user_list st
   WHERE     a1701sh.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1701sh.tp_kod = a1701shtps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a1701sh.h_fio_eta, :eta_list) =
                a1701sh.h_fio_eta
GROUP BY a1701sh.tab_num,
         st.fio,
         a1701sh.fio_eta,
         a1701sh.tp_ur,
         a1701sh.tp_addr,
         a1701sh.tp_kod,
         a1701shtps.contact_lpr
ORDER BY st.fio,
         a1701sh.fio_eta,
         a1701sh.tp_ur,
         a1701sh.tp_addr