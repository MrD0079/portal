/* Formatted on 16.11.2016 17:32:58 (QP5 v5.252.13127.32867) */
  SELECT a16115p.tab_num,
         st.fio fio_ts,
         a16115p.fio_eta,
         a16115p.tp_ur,
         a16115p.tp_addr,
         a16115p.tp_kod,
         a16115ptps.contact_lpr
    FROM a16115p_tp_select a16115ptps, a16115p, user_list st
   WHERE     a16115p.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a16115p.tp_kod = a16115ptps.tp_kod
         AND st.dpt_id = :dpt_id
         AND DECODE ( :eta_list, '', a16115p.h_fio_eta, :eta_list) =
                a16115p.h_fio_eta
GROUP BY a16115p.tab_num,
         st.fio,
         a16115p.fio_eta,
         a16115p.tp_ur,
         a16115p.tp_addr,
         a16115p.tp_kod,
         a16115ptps.contact_lpr
ORDER BY st.fio,
         a16115p.fio_eta,
         a16115p.tp_ur,
         a16115p.tp_addr