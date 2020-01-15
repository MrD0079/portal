/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1912tfpo.tab_num,
         st.fio fio_ts,
         a1912tfpo.fio_eta,
         a1912tfpo.tp_ur,
         a1912tfpo.tp_addr,
         a1912tfpo.tp_kod,
         a1912tfpotps.contact_lpr
    FROM a1912tfpo_tp_select a1912tfpotps, a1912tfpo, user_list st
   WHERE     a1912tfpo.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1912tfpo.tp_kod = a1912tfpotps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1912tfpo.h_fio_eta, :eta_list) =
                a1912tfpo.h_fio_eta
GROUP BY a1912tfpo.tab_num,
         st.fio,
         a1912tfpo.fio_eta,
         a1912tfpo.tp_ur,
         a1912tfpo.tp_addr,
         a1912tfpo.tp_kod,
         a1912tfpotps.contact_lpr
ORDER BY st.fio,
         a1912tfpo.fio_eta,
         a1912tfpo.tp_ur,
         a1912tfpo.tp_addr