/* Formatted on 29/01/2015 12:13:22 (QP5 v5.227.12220.39724) */
  SELECT a1608lj.tab_num,
         st.fio fio_ts,
         a1608lj.fio_eta,
         a1608lj.tp_ur,
         a1608lj.tp_addr,
         a1608lj.tp_kod,
         a1608ljtps.contact_lpr
    FROM a1608lj_tp_select a1608ljtps, a1608lj, user_list st
   WHERE     a1608lj.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1608lj.tp_kod = a1608ljtps.tp_kod
         AND st.dpt_id = :dpt_id and st.is_spd=1
         AND DECODE (:eta_list, '', a1608lj.h_fio_eta, :eta_list) =
                a1608lj.h_fio_eta
GROUP BY a1608lj.tab_num,
         st.fio,
         a1608lj.fio_eta,
         a1608lj.tp_ur,
         a1608lj.tp_addr,
         a1608lj.tp_kod,
         a1608ljtps.contact_lpr
ORDER BY st.fio,
         a1608lj.fio_eta,
         a1608lj.tp_ur,
         a1608lj.tp_addr