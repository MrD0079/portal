/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1807f.tab_num,
         st.fio fio_ts,
         a1807f.fio_eta,
         a1807f.tp_ur,
         a1807f.tp_addr,
         a1807f.tp_kod,
         a1807ftps.contact_lpr
    FROM a1807f_tp_select a1807ftps, a1807f, user_list st
   WHERE     a1807f.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1807f.tp_kod = a1807ftps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1807f.h_fio_eta, :eta_list) =
                a1807f.h_fio_eta
GROUP BY a1807f.tab_num,
         st.fio,
         a1807f.fio_eta,
         a1807f.tp_ur,
         a1807f.tp_addr,
         a1807f.tp_kod,
         a1807ftps.contact_lpr
ORDER BY st.fio,
         a1807f.fio_eta,
         a1807f.tp_ur,
         a1807f.tp_addr