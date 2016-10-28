/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1604sh.tab_num,
         st.fio fio_ts,
         a1604sh.fio_eta,
         a1604sh.tp_ur,
         a1604sh.tp_addr,
         a1604sh.tp_kod,
         a1604shtps.contact_lpr
    FROM a1604sh_tp_select a1604shtps, a1604sh, user_list st
   WHERE     a1604sh.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1604sh.tp_kod = a1604shtps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a1604sh.h_fio_eta, :eta_list) =
                a1604sh.h_fio_eta
GROUP BY a1604sh.tab_num,
         st.fio,
         a1604sh.fio_eta,
         a1604sh.tp_ur,
         a1604sh.tp_addr,
         a1604sh.tp_kod,
         a1604shtps.contact_lpr
ORDER BY st.fio,
         a1604sh.fio_eta,
         a1604sh.tp_ur,
         a1604sh.tp_addr