/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1709ao.tab_num,
         st.fio fio_ts,
         a1709ao.fio_eta,
         a1709ao.tp_ur,
         a1709ao.tp_addr,
         a1709ao.tp_kod,
         a1709aotps.contact_lpr
    FROM a1709ao_tp_select a1709aotps, a1709ao, user_list st
   WHERE     a1709ao.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1709ao.tp_kod = a1709aotps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1709ao.h_fio_eta, :eta_list) =
                a1709ao.h_fio_eta
GROUP BY a1709ao.tab_num,
         st.fio,
         a1709ao.fio_eta,
         a1709ao.tp_ur,
         a1709ao.tp_addr,
         a1709ao.tp_kod,
         a1709aotps.contact_lpr
ORDER BY st.fio,
         a1709ao.fio_eta,
         a1709ao.tp_ur,
         a1709ao.tp_addr